module Kemal
  module Shield
    # Generic Kemal::Shield error.
    class Error < Exception
    end

    # Exception raised when a dublicated handler is added using `Kemal::Shield.add_handler`.
    class DublicateHandlerError < Error
      def initialize(handler : Kemal::Shield::Handler, cause = nil)
        super "Received dublicate handler: #{handler.class}", cause
      end
    end
  end
end
