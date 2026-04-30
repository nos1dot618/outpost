module outpost.http.parser;

import std.array;
import outpost.http.request : HttpRequest;

// TODO: Add validations.
HttpRequest parseRequest(ubyte[] raw)
{
  HttpRequest request;

  auto parts = raw.split("\r\n\r\n");
  auto headerPart = parts[0];
  auto headerLines = headerPart.split("\r\n");
  auto requestLine = headerLines[0];
  auto requestLineParts = requestLine.split(" ");

  // GET /path/to/file HTTP/1.1
  request.method = cast(string) requestLineParts[0];
  request.path = cast(string) requestLineParts[1];
  request.version_ = cast(string) requestLineParts[2];

  foreach (line; headerLines[1 .. $])
  {
    auto kv = line.split(": ");
    if (kv.length != 2)
      request.headers[cast(string) kv[0]] = cast(string) kv[1];
  }

  if (parts.length > 1) request.body_ = cast(ubyte[]) parts[1];
  return request;
}
