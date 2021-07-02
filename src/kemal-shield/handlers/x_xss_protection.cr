require "kemal"

class Kemal::Shield::XXSSProtection < Kemal::Handler
  def call(context)
    if !Kemal::Shield.config.x_xss_protection
      context.response.headers["X-XSS-Protection"] = "0"
    end
    call_next(context)
  end
end
