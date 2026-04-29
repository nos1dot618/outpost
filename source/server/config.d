module outpost.server.config;

import std.typecons : Nullable;
import outpost.config : Config;
import outpost.server.protocols : Protocol;

struct ServerConfig
{
  enum DEFAULT_ROOT = "./";

  string root = DEFAULT_ROOT;
  ListenerConfig[] listenerConfigs;

  this(Config config)
  {
    root = config.getOrDefault!string("root", DEFAULT_ROOT);
    foreach (listenerJsonValue; config.getArray("listeners"))
    {
      listenerConfigs ~= ListenerConfig(new Config(listenerJsonValue));
    }
  }

}

struct ListenerConfig
{
  enum DEFAULT_PROTOCOL = Protocol.HTTP;
  enum DEFAULT_PORT = 8080;
  enum DEFAULT_BACKLOG = 50;

  string protocol;
  ushort port;
  uint backlog;

  // Protocol specific configurations.
  Nullable!HttpConfig httpConfig = Nullable!HttpConfig();
  Nullable!HttpsConfig httpsConfig = Nullable!HttpsConfig();

  this(Config config)
  {
    protocol = config.getOrDefault!string("protocol", DEFAULT_PROTOCOL);
    port = config.getOrDefault!ushort("port", DEFAULT_PORT);
    backlog = config.getOrDefault!uint("backlog", DEFAULT_BACKLOG);

    final switch (protocol)
    {
    case Protocol.HTTP:
      httpConfig = HttpConfig(config);
      break;
    case Protocol.HTTPS:
      httpsConfig = HttpsConfig(config);
      break;
    }
  }
}

struct HttpConfig
{
  enum DEFAULT_REDIRECT_TO_HTTPS = false;

  bool redirectToHttps = DEFAULT_REDIRECT_TO_HTTPS;

  this(Config config)
  {
    redirectToHttps = config.getOrDefault!bool("redirect-to-https",
                                               DEFAULT_REDIRECT_TO_HTTPS);
  }
}

struct HttpsConfig
{
  enum DEFAULT_CERTIFICATE_FILE_PATH = null;
  enum DEFAULT_PRIVATE_KEY_FILE_PATH = null;

  string certificateFilePath = DEFAULT_CERTIFICATE_FILE_PATH;
  string privateKeyFilePath = DEFAULT_PRIVATE_KEY_FILE_PATH;

  this(Config config)
  {
    certificateFilePath = config
      .getOrDefault!string("certificate-path",
                           DEFAULT_CERTIFICATE_FILE_PATH);
    privateKeyFilePath = config
      .getOrDefault!string("private-key-path",
                           DEFAULT_PRIVATE_KEY_FILE_PATH);
  }
}
