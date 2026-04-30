import std.stdio;
import outpost.config : Config;
import outpost.http.handlers.static_file_handler : staticFileHandler;
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

  server.addRequestHandler(route, staticFileHandler(root));
  server.listen();
  return 0;
}
