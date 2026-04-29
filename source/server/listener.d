module outpost.server.listener;

import std.concurrency;
import std.socket;
import parser = outpost.http.parser;
import log = outpost.log;
import outpost.http.router : HttpRequestRouter;
import outpost.server.config : ServerConfig;
import outpost.server.connection : Connection;
import connection_factory = outpost.server.connection_factory;
import outpost.server.tls_context : TlsContext;

void handle(Connection connection, HttpRequestRouter router)
{
  scope(exit) connection.close();

  ubyte[8192] buffer;
  auto received = connection.read(buffer);
  if (received <= 0) return;

  auto request = parser.parseRequest(buffer[0 .. received]);
  auto response = router.dispatch(request);

  connection.write(cast(const(ubyte)[])response.toString());
}

void start(ServerConfig config, HttpRequestRouter router)
{
  auto sock = new TcpSocket();
  sock.bind(new InternetAddress(config.port));
  sock.listen(config.backlog);
  log.info("Listening on localhost:%d with a backlog of %d.",
           config.port, config.backlog);
  log.info("TLS: %s.", config.enableTls ? "enabled" : "disabled");

  TlsContext tls;
  if (config.enableTls)
    tls = TlsContext(config.certificateFilePath, config.keyFilePath);

  while (true)
  {
    auto client = sock.accept();

    try
    {
      auto connection = connection_factory
        .createConnection(client, config, config.enableTls ? &tls : null);
      handle(connection, router);
    }
    catch (Exception e)
    {
      log.error("Connection error: %s.", e.msg);
      try client.close(); catch (Exception) {} // ignore secondary errors
    }
  }
}
