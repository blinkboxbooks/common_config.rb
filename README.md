# Blinkbox::CommonConfig

Put your reference properties in `config/reference.properties` and any environmental stuff which makes sense for a development environment in `config/application.properties`, then load them and access them with:

```ruby
# $ gem install blinkbox-common_config
require "blinkbox/common_config"

properties = Blinkbox::CommonConfig.new

# Accessible with symbols
properties[:'rabbitmq.url']
# Or strings
properties["rabbitmq.url"]
```

It will also load the properties file referenced in the environment variable `CONFIG_URL` so long as the file exists, or the http(s) URI responds with a 200 status code.