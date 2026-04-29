module outpost.server.tls_context;

import std.stdio;
import deimos.openssl.err;
import deimos.openssl.ssl;
import log = outpost.log;

struct TlsContext
{
  SSL_CTX* context;

  this(string certificateFilePath, string keyFilePath)
  {
    SSL_library_init();
    SSL_load_error_strings();

    const SSL_METHOD* method = TLS_server_method();
    context = SSL_CTX_new(method);
    if (context is null)
    {
      log.error("Failed to create SSL_CTX.");
      ERR_print_errors_cb(&log.errorCallback, null);
      assert(0);
    }

    if (SSL_CTX_use_certificate_file(context, certificateFilePath.ptr,
                                     SSL_FILETYPE_PEM) != 1 ||
        SSL_CTX_use_PrivateKey_file(context, keyFilePath.ptr,
                                    SSL_FILETYPE_PEM) != 1 ||
        SSL_CTX_check_private_key(context) != 1)
    {
      log.error("Certificate and private key mismatch.");
      ERR_print_errors_cb(&log.errorCallback, null);
      assert(0);
    }
  }
}
