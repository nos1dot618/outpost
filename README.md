## Getting Started

```bash
bash setup.sh
dub run -- samples/config.json
```

Starts the server using the provided configuration.

## Testing the Server

### HTTP

```bash
curl -v http://localhost:8080/README.md
```

### HTTPS

```bash
curl -vk https://localhost:8443/README.md
```

* `-k`: allows self-signed certificates (development only).
