module outpost.server.server;

import outpost.http.router : HttpRequestHandler, HttpRequestRouter;
import listener = outpost.server.listener;

class HttpServer
{
  private HttpRequestRouter router;

  this()
  {
    router = new HttpRequestRouter();
  }

  void addRequestHandler(string path, HttpRequestHandler handler) =>
    router.add(path, handler);

  void listen(ushort port) => listener.start(port, router);
}
