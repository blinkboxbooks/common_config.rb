# Changelog

## Open Source release (2015-01-28 14:11:21)

Today we have decided to publish parts of our codebase on Github under the [MIT licence](LICENCE). The licence is very permissive, but we will always appreciate hearing if and where our work is used!

## 0.4.0 ([#6](https://git.mobcastdev.com/Platform/common_config.rb/pull/6) 2014-10-03 15:41:55)

No deep setting

### Breaking change

- Should not have changed this to using deep setting (other apps depend on it being single keys, and this is more flexible)

## 0.3.1 ([#3](https://git.mobcastdev.com/Platform/common_config.rb/pull/3) 2014-08-18 09:46:37)

Depth

### Clarification

- Made improvements to the tests and code so that the form of nested properties when using the `tree` method is well defined.

## 0.3.0 ([#4](https://git.mobcastdev.com/Platform/common_config.rb/pull/4) 2014-09-25 10:00:48)

Symbols and booleans

### New feature

- Converts `"true"` and `"false"` to boolean values.
- Converts `":thing"` to `:thing` symbols.

## 0.2.0 ([#2](https://git.mobcastdev.com/Platform/common_config.rb/pull/2) 2014-08-13 16:33:04)

Use units in properties

### New Feature

- Properties in the format `5 seconds` will be converted to [Unit](https://github.com/olbrich/ruby-units) objects so that they can be easily manipulated:

```ruby
property = Unit("6 minutes")

p property.convert_to("seconds").scalar
### => 360
```

## 0.1.0

Initial release

### New features

- Reads `config/reference.properties`, overwrites with `config/application.properties` (if it exists) then overwrites with contents of the file or URL at `ENV['CONFIG_URL']` (if it exists/responds with HTTP 200)