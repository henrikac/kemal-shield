require "kemal"

class Kemal::Shield::CrossOriginOpenerPolicy < Kemal::Handler
  def call(context)
    policy = Kemal::Shield.config.cross_origin_opener_policy
    context.response.headers["Cross-Origin-Opener-Policy"] = policy
    call_next(context)
  end
end
