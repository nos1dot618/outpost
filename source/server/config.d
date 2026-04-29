module outpost.server.config;

import outpost.config : Config;

struct ServerConfig
{
  enum DEFAULT_PORT = 8080;
  enum DEFAULT_BACKLOG = 50;
  enum DEFAULT_TLS_STATE = true;
  enum DEFAULT_CERTIFICATE_FILE_PATH = null;
  enum DEFAULT_KEY_FILE_PATH = null;

  ushort port = DEFAULT_PORT;
  uint backlog = DEFAULT_BACKLOG;
  bool enableTls = DEFAULT_TLS_STATE;
  string certificateFilePath = DEFAULT_CERTIFICATE_FILE_PATH;
  string keyFilePath = DEFAULT_KEY_FILE_PATH;

  this(Config config)
  {
    port = config.getOrDefault!ushort("port", DEFAULT_PORT);
    backlog = config.getOrDefault!uint("backlog", DEFAULT_BACKLOG);
    enableTls = config.getOrDefault!bool("tls.enable", DEFAULT_TLS_STATE);
    certificateFilePath = config
      .getOrDefault!string("tls.certificate-path",
                           DEFAULT_CERTIFICATE_FILE_PATH);
    keyFilePath = config
      .getOrDefault!string("tls.private-key-path", DEFAULT_KEY_FILE_PATH);
  }
}
