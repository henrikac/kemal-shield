require "kemal"

class Kemal::Shield::CrossOriginResourcePolicy < Kemal::Handler
  def call(context)
    policy = Kemal::Shield.config.cross_origin_resource_policy
    context.response.headers["Cross-Origin-Resource-Policy"] = policy
    call_next(context)
  end
end
