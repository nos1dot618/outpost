 module outpost.server.listener;

import std.socket;
import outpost.http.router : HttpRequestRouter;
import connection = outpost.server.connection;

void start(ushort port, HttpRequestRouter router)
{
  auto sock = new TcpSocket();
  sock.bind(new InternetAddress(port));
  sock.listen(50);

  while (true)
  {
    auto client = sock.accept();
    connection.handleConnection(client, router);
  }
}
