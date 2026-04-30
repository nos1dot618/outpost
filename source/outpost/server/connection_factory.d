module outpost.server.connection_factory;

import std.socket;
import outpost.server.protocols : Protocol;
import outpost.server.connection : Connection;
import outpost.server.tcp_connection : TcpConnection;
import outpost.server.tls_connection : TlsConnection;
import outpost.server.tls_context : TlsContext;

Connection createConnection(Socket sock, Protocol protocol, TlsContext* tls)
{
  final switch (protocol)
  {
  case Protocol.HTTP: return new TcpConnection(sock);
  case Protocol.HTTPS:
    assert(tls !is null, "TLS context required for HTTPS");
    return new TlsConnection(new TcpConnection(sock), tls.context);
  }
}
