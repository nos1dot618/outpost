module outpost.http.headers;

struct HttpHeaders
{
  private string[string] headers;

  bool has(HttpHeaderKey key) const => (key in headers) !is null;
  string opIndex(HttpHeaderKey key) const => this.has(key) ? headers[key] : null;

  void opIndexAssign(string value, HttpHeaderKey key)
  {
    headers[key] = value;
  }

  int opApply(int delegate(string, string) lambda) const
  {
    foreach (key, value; headers)
    {
      auto result = lambda(key, value);
      if (result) return result;
    }
    return 0;
  }

  HttpHeaders dup() const
  {
    HttpHeaders other;
    other.headers = this.headers.dup;
    return other;
  }
}

enum HttpHeaderKey : string
{
  Connection = "connection",
  ContentLength = "content-length",
  ContentType = "content-type"
}

enum ConnectionType : string
{
  Close = "close",
  KeepAlive = "keep-alive"
}

enum MimeType
{
  TextPlain = "text/plain",
  OctetStream = "application/octet-stream" // Default fallback value.
}

struct ContentType
{
  MimeType mime = MimeType.OctetStream;
  string charSet = "";

  this(MimeType mime)
  {
    this.mime = mime;
  }

  string toString() const =>
    charSet.length ? mime ~ "; charset=" ~ charSet : mime;
}

void setConnection(ref HttpHeaders headers, ConnectionType connection)
{
  headers[HttpHeaderKey.Connection] = connection;
}

void setContentLength(ref HttpHeaders headers, ulong len)
{
  import std.conv : to;
  headers[HttpHeaderKey.ContentLength] = to!string(len);
}

void setContentType(ref HttpHeaders headers, ContentType contentType)
{
  headers[HttpHeaderKey.ContentType] = contentType.toString();
}
