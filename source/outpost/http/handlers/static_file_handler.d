module outpost.http.handlers.static_file_handler;

import std.file : exists, read;
import headers = outpost.http.headers;
import outpost.http.path_sanitiser : sanitisePath;
import outpost.http.response : HttpResponse;
import outpost.http.router : HttpRequestHandler;
import outpost.http.statuses : HttpStatus;
import log = outpost.log;

HttpRequestHandler staticFileHandler(string root)
{
  return (request) {
    auto sanitisedPath = sanitisePath(root, request.path);
    log.note(request.requestLine());
    if (sanitisedPath.isNull) return HttpResponse(HttpStatus.Forbidden);
    log.note("Path requested: %s.", sanitisedPath);
    if (!exists(sanitisedPath.get)) return HttpResponse(HttpStatus.NotFound);

    auto content = cast(ubyte[]) read(sanitisedPath.get);
    headers.HttpHeaders headers_;
    headers.setConnection(headers_, headers.ConnectionType.Close);
    return HttpResponse(HttpStatus.Ok, headers_, content);
  };
}
