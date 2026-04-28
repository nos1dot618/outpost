module outpost.http.router;

import outpost.http.headers : HttpHeader;
import outpost.http.request : HttpRequest;
import outpost.http.response : HttpResponse;
import outpost.http.statuses : HttpStatus;

alias HttpRequestHandler = HttpResponse function(HttpRequest);

class HttpRequestRouter
{
  private HttpRequestHandler[string] routes;

  void add(string path, HttpRequestHandler handler)
  {
    routes[path] = handler;
  }

  HttpResponse dispatch(HttpRequest request)
  {
    if (auto handler = request.path in routes) return (*handler)(request);
    return HttpResponse(HttpStatus.NotFound,
                        [HttpHeader.ContentType: "text/plain"],
                        cast(ubyte[]) "404");
  }
}
