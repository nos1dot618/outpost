import std.stdio;

import std.file : exists, read;
import outpost.http.headers : HttpHeader;
import outpost.http.path_sanitiser : sanitisePath;
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
  auto root = config.getOrDefault!string("root", "./");
  auto route = config.getOrDefault!string("route", "/");

  server.addRequestHandler(route, (request) {
      auto sanitisedPath = sanitisePath(root, request.path);
      log.note(request.requestLine());
      if (sanitisedPath.isNull) return HttpResponse(HttpStatus.Forbidden);
      log.note("Path requested: %s.", sanitisedPath);
      if (!exists(sanitisedPath.get)) return HttpResponse(HttpStatus.NotFound);

      auto content = cast(ubyte[]) read(sanitisedPath.get);
      return HttpResponse(HttpStatus.Ok,
                          [HttpHeader.ContentType: "application/octet-stream",
                           HttpHeader.Connection: "close"],
                          content);
    });

  server.listen();
  return 0;
}
