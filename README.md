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

Kemal::Shield.activate # => adds handlers with their default settings

get "/" do
  "Home"
end

Kemal.run
```

#### Managing handlers
##### Add handlers
The handlers can also be added individually as you would add any other handler.
The recommended way of adding handlers is to use `Kemal::Shield.add_handler` instead of Kemal's built-in `add_handler`.
The reason for using `Kemal::Shield.add_handler` over Kemal's built-in `add_handler` is that `Kemal::Shield.add_handler` keeps track of all `Kemal::Shield::Handler`.
It also makes sure that no dublicate `Kemal::Shield::Handler` is being added.

```crystal
Kemal::Shield.add_handler Kemal::Shield::XPoweredBy.new
Kemal::Shield.add_handler Kemal::Shield::XFrameOptions.new("DENY")
```

A `Kemal::Shield::DublicateHandlerError` is raised if a dublicate handler is added.

##### Remove handlers
There are two ways of removing a `Kemal::Shield::Handler`.  

1. `Kemal::Shield.remove_handler´ if you just need to remove a single handler
2. `Kemal::Shield.deactivate` if you want to remove all `Kemal::Shield::Handler`.

```crystal
Kemal::Shield.remove_handler Kemal::Shield::ExpectCT
```

#### Custom handler
Creating a new handler works just as creating a regular Kemal handler.
The only difference is that the new handlers should inherit from `Kemal::Shield::Handler` instead of `Kemal::Handler`.

```crystal
class CustomHandler < Kemal::Shield::Handler
  def call(context)
    # code ...
    call_next context
  end
end
```

This makes it possible to add handlers using `Kemal::Shield.add_handler` and/or remove handlers using `Kemal::Shield.remove_handler` or `Kemal::Shield.deactivate`.

#### Configuration
The different headers can be configured in the same way as Kemal:

```crystal
Kemal::Shield.config do |config|
  config.csp_on = true
  config.hide_powered_by = true
  config.no_sniff = true
  config.referrer_policy = ["no-referrer"]
  config.x_xss_protection = false
end
```
or
```crystal
Kemal::Shield.config.hide_powered_by = true
```

Configuration should be done before calling `Kemal::Shield.activate`.
This is to make sure that the handlers will use the custom configurations.

```crystal
Kemal::Shield.config.corp = "cross-origin" # => Good: This will be used when calling .activate

Kemal::Shield.activate

Kemal::Shield.config.corp = "same-site" # => Bad: Handlers has already been initialized
```

| Option | Description | Default |
|---|---|---|
| csp_on | Set Content-Security-Policy header | `true` |
| csp_defaults | Add CSP default directives | `true` |
| csp_directives | CSP directives | `DEFAULT_DIRECTIVES` |
| csp_report_only | Set Content-Security-Policy-Report-Only header | `false` |
| coep_on | Set Cross-Origin-Embedder-Policy header | `true` |
| coop_on | Set Cross-Origin-Opener-Policy header | `true` |
| coop | Cross-Origin-Opener-Policy policy | `"same-origin"` |
| corp_on | Set Cross-Origin-Resource-Policy header | `true` |
| corp | Cross-Origin-Resource-Policy policy | `"same-origin"` |
| expect_ct | Set Expect-CT header | `true` |
| expect_ct_max_age | Seconds the user agent should regard the host of the received message as a known Expect-CT host | `0` |
| expect_ct_enforce | Whether the user agent should enforce compliance with the Certificate Transparency policy | `false` |
| expect_ct_report_uri | The URI where the user agent should report Expect-CT failures | `""` |
| hide_powered_by | Whether to remove the X-Powered-By header | `true` |
| no_sniff | Set X-Content-Type-Options header  | `true` |
| oac | Set Origin-Agent-Cluster header | `true` |
| referrer_on | Set Referrer-Policy header | `true` |
| referrer_policy | The Referrer-Policy policy | `["no-referrer"]` |
| sts_on | Set Strict-Transport-Security | `true` |
| sts_max_age | Seconds that the browser should remember that a site is only to be accessed using HTTPS | `15_552_000` |
| sts_include_sub | Add rule to subdomains | `true` |
| sts_preload | [Preloading STS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security#preloading_strict_transport_security) | `false` |
| x_dns_prefetch_control_on | Set X-DNS-Prefetch-Control header | `true` |
| x_dns_prefetch_control | Enable DNS prefetching | `false` |
| x_download_options | Set X-Download-Options header | `true` |
| x_frame_options_on | Set X-Frame-Options | `true` |
| x_frame_options | X-Frame-Options directive | `"SAMEORIGIN"` |
| x_permitted_cross_domain_policies_on | Set X-Permitted-Cross-Domain-Policies header | `true` |
| x_permitted_cross_domain_policies | X-Permitted-Cross-Domain-Policies directive | `none` |
| x_xss_protection | Enable X-XSS-Protection header | `false` |


`ContentSecurityPolicy::DEFAULT_DIRECTIVES`:
```
default-src 'self';
base-uri 'self';
block-all-mixed-content;
font-src 'self' https: data:;
frame-ancestors 'self';
img-src 'self' data:;
object-src 'none';
script-src 'self';
script-src-attr 'none';
style-src 'self' https: 'unsafe-inline';
upgrade-insecure-requests;
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
