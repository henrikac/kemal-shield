require "kemal"

class Kemal::Shield::XFrameOptions < Kemal::Handler
  def call(context)
    context.response.headers["X-Frame-Options"] = Kemal::Shield.config.x_frame_options
    call_next(context)
  end
end
