require "kemal"

class Kemal::Shield::ReferrerPolicy < Kemal::Handler
  def call(context)
    context.response.headers["Referrer-Policy"] = Kemal::Shield.config.referrer_policy
    call_next(context)
  end
end
