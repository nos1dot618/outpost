module outpost.server.protocols;

enum Protocol : string
{
  HTTP = "http",
  HTTPS = "https"
}

Protocol toProtocol(string protocol)
{
  final switch (protocol)
  {
  case Protocol.HTTP: return Protocol.HTTP;
  case Protocol.HTTPS: return Protocol.HTTPS;
  }
}
