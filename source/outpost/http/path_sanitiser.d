module outpost.http.path_sanitiser;

import std.algorithm : startsWith;
import std.array;
import std.path : absolutePath, buildPath, asNormalizedPath;
import std.string : indexOf, replace;
import std.uri : decodeComponent;
import std.typecons : Nullable, nullable;
import log = outpost.log;

Nullable!string sanitisePath(string root, string requestPath)
{
  // Reject empty path.
  if (requestPath.length == 0) return Nullable!string();

  auto processedPath = requestPath;

  // Strip query (?) and fragment (#).
  {
    auto i = processedPath.indexOf('?');
    if (i != -1) processedPath = processedPath[0 .. i];
    i = processedPath.indexOf('#');
    if (i != -1) processedPath = processedPath[0 .. i];
  }

  // Decode URL (To mitigate %2e%2e type attacks).
  try processedPath = decodeComponent(processedPath);
  catch (Exception e)
  {
    log.error("Invalid URI encoding: %s.", e.msg);
    return Nullable!string();
  }

  // Normalize slashes.
  processedPath = processedPath.replace("\\", "/");

  // Remove leading slash.
  if (processedPath.length > 1 && processedPath[0] == '/')
    processedPath = processedPath[1 .. $];

  // Prevent NULL byte injection.
  foreach (ch; processedPath)
    if (ch == '\0')
    {
      log.error("NULL byte detected inside request URI.");
      return Nullable!string();
    }

  auto absoluteRoot = asNormalizedPath(absolutePath(root)).array;
  auto sanitisedPath = cast(string)
    asNormalizedPath(buildPath(absoluteRoot, processedPath)) .array;

  // Enforce boundary check.
  if (!sanitisedPath.startsWith(absoluteRoot ~ '/') &&
      sanitisedPath != absoluteRoot)
  {
    log.error("Path escapes root.");
    return Nullable!string();    
  }

  return nullable(sanitisedPath);
}
