require "kemal"

class Kemal::Shield::XPoweredBy < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.hide_powered_by
      context.response.headers.delete("X-Powered-By")
    end
    call_next(context)
  end
end
