require "kemal"

# `Kemal::Shield::CrossOriginEmbedderPolicy` is a handler that sets the
# Cross-Origin-Embedder-Policy HTTP header.
#
# This handler can be turned off by setting
# ```
# Kemal::Shield.config.cross_origin_embedder_policy = false
# ```
class Kemal::Shield::CrossOriginEmbedderPolicy < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.cross_origin_embedder_policy
      context.response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
    end
    call_next(context)
  end
end
