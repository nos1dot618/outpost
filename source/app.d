import std.stdio;

import outpost.http.response : HttpResponse;
import outpost.http.statuses : HttpStatus;
import outpost.server.server : HttpServer;

void main()
{
  auto server = new HttpServer();

  server.addRequestHandler("/", (request) {
      return HttpResponse(HttpStatus.Ok, ["Content-Type":"text/plain"],
                          cast(ubyte[])"Hello World");
    });

  server.listen(8080);
}
