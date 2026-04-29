module outpost.server.tls_connection;

import std.socket;
import deimos.openssl.ssl;
import deimos.openssl.err;
import log = outpost.log;
import outpost.server.connection : Connection;
import outpost.server.tcp_connection : TcpConnection;

class TlsConnection : Connection
{
  private TcpConnection tcp;
  private SSL* ssl;
  
  this(TcpConnection tcp, SSL_CTX* sslContext)
  {
    this.tcp = tcp;

    ssl = SSL_new(sslContext);
    SSL_set_fd(ssl, tcp.raw.handle);
    if (SSL_accept(ssl) <= 0)
    {
      log.error("Failed to accept SSL connection.");
      ERR_print_errors_cb(&log.errorCallback, null);

      SSL_free(ssl);
      tcp.close();
      throw new Exception("TLS handshake failed");
    }
  }

  override long read(ubyte[] buffer) =>
    cast(long) SSL_read(ssl, buffer.ptr, cast(int) buffer.length);
  override long write(const(ubyte)[] data) =>
    cast(long) SSL_write(ssl, data.ptr, cast(int) data.length);
  override void close()
  {
    SSL_shutdown(ssl);
    SSL_free(ssl);
    tcp.close();
  }
}
