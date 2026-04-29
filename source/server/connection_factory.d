module outpost.server.connection_factory;

import std.socket;
import outpost.server.config : ServerConfig;
import outpost.server.connection : Connection;
import outpost.server.tcp_connection : TcpConnection;
import outpost.server.tls_connection : TlsConnection;
import outpost.server.tls_context : TlsContext;

Connection createConnection(Socket sock, ServerConfig config, TlsContext* tls)
{
  auto tcp = new TcpConnection(sock);
  if (config.enableTls) return new TlsConnection(tcp, tls.context);
  return tcp;
}
