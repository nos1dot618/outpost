module outpost.server.server;

import outpost.http.router : HttpRequestHandler, HttpRequestRouter;
import outpost.server.config : ServerConfig;
import listener = outpost.server.listener;

class HttpServer
{
  private ServerConfig config;
  private HttpRequestRouter router;

  this(ServerConfig config)
  {
    this.config = config;
    router = new HttpRequestRouter();
  }

  void addRequestHandler(string path, HttpRequestHandler handler) =>
    router.add(path, handler);

  void listen() => listener.start(config, router);
}
