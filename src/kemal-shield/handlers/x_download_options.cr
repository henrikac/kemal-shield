require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::XDownloadOptions` is a handler that sets the X-Download-Options HTTP header.
    #
    # Setting X-Download-Options to "noopen" helps preventing Internet Explorer users from executing
    # downloads in your site's context.
    #
    # This handler can be turned off by setting:
    # ```
    # Kemal::Shield.config.x_download_options = false
    # ```
    class XDownloadOptions < Shield::Handler
      def call(context)
        if Kemal::Shield.config.x_download_options
          context.response.headers["X-Download-Options"] = "noopen"
        end
        call_next(context)
      end
    end
  end
end
