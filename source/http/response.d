module outpost.http.response;

import std.conv;
import headers = outpost.http.headers;
import outpost.http.statuses : HttpStatus;

struct HttpResponse
{
  HttpStatus status = HttpStatus.Ok;
  headers.HttpHeaders headers_;
  ubyte[] body_;

  this(HttpStatus status)
  {
    this.status = status;

    // TODO: Support keep-alive connections.
    headers.setConnection(this.headers_, headers.ConnectionType.Close);
    headers.setContentType(this.headers_,
                           headers.ContentType(headers.MimeType.TextPlain));

    this.body_ = cast(ubyte[]) status.toString();
  }

  this(HttpStatus status, headers.HttpHeaders headers_, ubyte[] body_)
  {
    this.status = status;
    this.headers_ = headers_;
    this.body_ = body_;
  }

  string toString() const
  {
    auto result = "HTTP/1.1 " ~ status.toString() ~ " \r\n";
    auto localHeaders = headers_.dup;
    if (!localHeaders.has(headers.HttpHeaderKey.ContentLength))
      headers.setContentLength(localHeaders, body_.length);
    foreach (k, v; localHeaders) result ~= k ~ ": " ~ v ~ "\r\n";
    result ~= "\r\n";
    result ~= body_;
    return result;
  }
}
