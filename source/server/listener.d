module outpost.server.listener;

import std.concurrency;
import std.socket;
import outpost.http.parser : parseRequest;
import outpost.http.router : HttpRequestRouter;
import log = outpost.log;
import outpost.server.config : ServerConfig, ListenerConfig;
import outpost.server.connection : Connection;
import connection_factory = outpost.server.connection_factory;
import outpost.server.protocols : Protocol, toProtocol;
import outpost.server.tls_context : TlsContext;

void handle(Connection connection, shared(HttpRequestRouter) router)
{
  scope(exit) connection.close();

  ubyte[8192] buffer;
  auto received = connection.read(buffer);
  if (received <= 0) return;

  auto request = parseRequest(buffer[0 .. received]);
  auto response = router.dispatch(request);

  connection.write(cast(const(ubyte)[])response.toString());
}

void runListener(ListenerConfig config, shared(HttpRequestRouter) router)
{
  auto sock = new TcpSocket();
  sock.bind(new InternetAddress(config.port));
  sock.listen(config.backlog);
  log.info("Listening on %s://localhost:%d, backlog=%d.",
           config.protocol, config.port, config.backlog);

  // TLS Context set up (only for HTTPS).
  TlsContext tls;
  if (config.protocol == Protocol.HTTPS)
  {
    auto https = config.httpsConfig.get;
    tls = TlsContext(https.certificateFilePath, https.privateKeyFilePath);
  }

  while (true)
  {
    auto client = sock.accept();
    try
    {
      auto connection = connection_factory
        .createConnection(client, toProtocol(config.protocol), &tls);
      handle(connection, router);
    }
    catch (Exception e)
    {
      log.error("Connection error on port %d: %s", config.port, e.msg);
      try client.close(); catch (Exception) {}
    }
  }
}

void start(ServerConfig config, HttpRequestRouter router)
{
  foreach (listenerConfig; config.listenerConfigs)
    spawn(&runListener, listenerConfig, cast(shared) router);
}
