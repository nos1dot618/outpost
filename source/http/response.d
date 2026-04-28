module outpost.http.response;

import std.conv;
import outpost.http.headers : HttpHeader;
import outpost.http.statuses : HttpStatus;

struct HttpResponse
{
  HttpStatus status = HttpStatus.Ok;
  string[string] headers;
  ubyte[] body_;

  string toString() const @safe nothrow
  {
    auto result = "HTTP/1.1 " ~ status.toString() ~ " \r\n";
    auto localHeaders = headers.dup;
    if (HttpHeader.ContentLength !in localHeaders)
      localHeaders[HttpHeader.ContentLength] = to!string(body_.length);
    foreach (k, v; localHeaders) result ~= k ~ ": " ~ v ~ "\r\n";
    result ~= "\r\n";
    result ~= body_;
    return result;
  }
}
