require "kemal"

class Kemal::Shield::XDownloadOptions < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.x_download_options
      context.response.headers["X-Download-Options"] = "noopen"
    end
    call_next(context)
  end
end
