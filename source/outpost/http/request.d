module outpost.http.request;

struct HttpRequest
{
  string method;
  string path;
  string version_;
  string[string] headers;
  ubyte[] body_;

  string requestLine() const @safe nothrow =>
    method ~ " " ~ path ~ " " ~ version_;
}
