# kemal-shield

This is a shard that adds an extra layer of protection to your [Kemal](https://github.com/kemalcr/kemal) app. This is done by setting various HTTP headers.  

This shard is inspired by [Helmet](https://github.com/helmetjs/helmet).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     kemal-shield:
       github: henrikac/kemal-shield
   ```

2. Run `shards install`

## Usage

#### Basic usage
```crystal
require "kemal"
require "kemal-shield"

Kemal::Shield::All.new # => adds handlers with their default settings

get "/" do
  "Home"
end

Kemal.run
```

The handlers can also be added individually as you would add any other handler

```crystal
add_handler Kemal::Shield::XPoweredBy.new
```

#### Configure handlers
The different headers can be configured in the same way as Kemal:

```crystal
Kemal::Shield.config do |config|
  config.csp_on = true
  config.hide_powered_by = true
  config.no_sniff = true
  config.referrer_policy = "no-referrer"
  config.x_xss_protection = false
end
```
or
```crystal
Kemal::Shield.config.hide_powered_by = true
```

#### Handlers
+ `ContentSecurityPolicy`
+ `CrossOriginEmbedderPolicy`
+ `CrossOriginOpenerPolicy`
+ `CrossOriginResourcePolicy`
+ `ExpectCT`
+ `OriginAgentCluster`
+ `ReferrerPolicy`
+ `StrictTransportSecurity`
+ `XContentTypeOptions`
+ `XDNSPrefetchControl`
+ `XDownloadOptions`
+ `XFrameOptions`
+ `XPermittedCrossDomainPolicies`
+ `XPoweredBy`
+ `XXSSProtection`

## Contributing

1. Fork it (<https://github.com/henrikac/kemal-shield/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Henrik Christensen](https://github.com/henrikac) - creator and maintainer
