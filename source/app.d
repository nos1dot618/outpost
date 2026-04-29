import std.stdio;

import outpost.http.response : HttpResponse;
import outpost.http.statuses : HttpStatus;
import outpost.config : Config;
import log = outpost.log;
import outpost.server.config : ServerConfig;
import outpost.server.server : HttpServer;

int main(string[] args)
{
  if (args.length < 2)
  {
    log.error("Usage: outpost <config.json>");
    return 1;
  }

  auto config = new Config(args[1]);
  auto server = new HttpServer(ServerConfig(config));

  server.addRequestHandler("/", (request) {
      return HttpResponse(HttpStatus.Ok, ["Content-Type":"text/plain"],
                          cast(ubyte[])"Hello World");
    });

  server.listen();
  return 0;
}
