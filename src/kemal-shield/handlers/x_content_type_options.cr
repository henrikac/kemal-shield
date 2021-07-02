require "kemal"

class Kemal::Shield::XContentTypeOptions < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.no_sniff
      context.response.headers["X-Content-Type-Options"] = "nosniff"
    end
    call_next(context)
  end
end
