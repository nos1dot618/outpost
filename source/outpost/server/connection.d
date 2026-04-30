module outpost.server.connection;

interface Connection
{
  long read(ubyte[] buffer);
  long write(const(ubyte)[] buffer);
  void close();
}
