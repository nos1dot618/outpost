module outpost.server.tcp_connection;

import std.socket;
import outpost.server.connection : Connection;

class TcpConnection : Connection
{
  private Socket sock;

  this(Socket sock)
  {
    this.sock = sock;
  }

  override long read(ubyte[] buffer) => sock.receive(buffer);
  override long write(const(ubyte)[] data) => sock.send(data);
  override void close() => sock.close();

  Socket raw() => sock;
}
