# Changelog

## 0.1.0

Initial release

### New features

- Reads `config/reference.properties`, overwrites with `config/application.properties` (if it exists) then overwrites with contents of the file or URL at `ENV['CONFIG_URL']` (if it exists/responds with HTTP 200)