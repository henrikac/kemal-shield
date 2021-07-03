require "kemal"

# `Kemal::Shield::XFrameOptions` is a handler that sets the X-Frame-Options HTTP header.
# This header restricts who can put your site in a frame which can help mitigate things
# like clickjacking attacks.
#
# This handler sets the X-Frame-Options header to "SAMEORIGIN" by default.
#
# `Kemal::Shield::XFrameOptions` only supports "SAMEORIGIN" and "DENY".
#
# The X-Frame-Options header can be updated by changing the value of:
# ```
# Kemal::Shield.config.x_frame_options
# ```
class Kemal::Shield::XFrameOptions < Kemal::Handler
  def call(context)
    context.response.headers["X-Frame-Options"] = Kemal::Shield.config.x_frame_options
    call_next(context)
  end
end
