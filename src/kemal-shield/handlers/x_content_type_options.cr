require "kemal"

# `Kemal::Shield::XContentTypeOptions` is a handler that sets the
# X-Content-Type-Options HTTP header.
#
# The default value is "nosniff".
#
# This handler can be turned off by setting
# ```
# Kemal::Shield.config.x_content_type_options = false
# ```
class Kemal::Shield::XContentTypeOptions < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.no_sniff
      context.response.headers["X-Content-Type-Options"] = "nosniff"
    end
    call_next(context)
  end
end
