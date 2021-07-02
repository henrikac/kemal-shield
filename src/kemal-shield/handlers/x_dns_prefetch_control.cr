require "kemal"

class Kemal::Shield::XDNSPrefetchControl < Kemal::Handler
  def call(context)
    value = Kemal::Shield.config.x_dns_prefetch_control ? "on" : "off"
    context.response.headers["X-DNS-Prefetch-Control"] = value
    call_next(context)
  end
end
