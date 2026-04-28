module outpost.server.connection;

import std.socket;
import parser = outpost.http.parser;
import outpost.http.router : HttpRequestRouter;

void handleConnection(Socket client, HttpRequestRouter router)
{
  scope(exit) client.close();

  ubyte[8192] buffer;
  auto received = client.receive(buffer);
  if (received <= 0) return;

  auto raw = cast(ubyte[]) buffer[0 .. received];
  auto request = parser.parseRequest(raw);
  auto response = router.dispatch(request);

  client.send(response.toString());
}
