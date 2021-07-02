require "kemal"

class Kemal::Shield::CrossOriginEmbedderPolicy < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.cross_origin_embedder_policy
      context.response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
    end
    call_next(context)
  end
end
