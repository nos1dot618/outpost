module outpost.http.router;

import std.algorithm : startsWith;
import outpost.http.headers : HttpHeader;
import outpost.http.request : HttpRequest;
import outpost.http.response : HttpResponse;
import outpost.http.statuses : HttpStatus;
import log = outpost.log;

alias HttpRequestHandler = HttpResponse delegate(HttpRequest);

class HttpRequestRouter
{
  private HttpRequestHandler[string] routes;

  void add(string path, HttpRequestHandler handler)
  {
    routes[path] = handler;
  }

  HttpResponse dispatch(HttpRequest request) shared
  {
    HttpRequestHandler bestHandler;
    size_t bestLength = 0;

    foreach (path, handler; routes)
      if (request.path.startsWith(path) && path.length > bestLength)
      {
        bestHandler = handler;
        bestLength = path.length;
      }

    if (bestHandler !is null) return bestHandler(request);
    log.note("Failed to find route for path: %s.", request.path);
    return HttpResponse(HttpStatus.NotFound);
  }
}
