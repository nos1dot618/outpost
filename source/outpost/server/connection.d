module outpost.server.connection;

interface Connection
{
  // TODO: Introduce streaming responses or memory-mapped files.
  long read(ubyte[] buffer);
  long write(const(ubyte)[] buffer);
  void close();
}
