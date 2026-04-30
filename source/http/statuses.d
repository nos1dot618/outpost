module outpost.http.statuses;

import std.conv;

struct HttpStatus
{
  int code;
  string text;

  enum Ok = HttpStatus(200, "OK");
  enum Forbidden = HttpStatus(403, "Forbidden");
  enum NotFound = HttpStatus(404, "Not Found");

  string toString() const @safe nothrow => to!string(code) ~ " " ~ text;
}
