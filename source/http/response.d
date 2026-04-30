module outpost.http.response;

import std.conv;
import outpost.http.headers : HttpHeader;
import outpost.http.statuses : HttpStatus;

struct HttpResponse
{
  HttpStatus status = HttpStatus.Ok;
  string[string] headers;
  ubyte[] body_;

  this(HttpStatus status)
  {
    this.status = status;
    // TODO: Support keep-alive connections.
    this.headers = [HttpHeader.ContentType: "text/plain",
                    HttpHeader.Connection: "close"];
    this.body_ = cast(ubyte[]) status.toString();
  }

  this(HttpStatus status, string[string] headers, ubyte[] body_)
  {
    this.status = status;
    this.headers = headers;
    this.body_ = body_;
  }

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
