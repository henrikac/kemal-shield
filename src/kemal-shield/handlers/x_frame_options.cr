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
#
# This handler can be turned off by setting
# ```
# Kemal::Shield.config.x_frame_options_on = false
# ```
class Kemal::Shield::XFrameOptions < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.x_frame_options_on
      context.response.headers["X-Frame-Options"] = Kemal::Shield.config.x_frame_options
    end
    call_next(context)
  end
end
