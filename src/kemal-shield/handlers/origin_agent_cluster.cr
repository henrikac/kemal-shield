require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::OriginAgentCluster` is a handler that set the Origin-Agent-Cluster HTTP header.
    #
    # This header can be turned off by setting
    # ```
    # Kemal::Shield.config.aoc = false
    # ```
    class OriginAgentCluster < Shield::Handler
      def call(context)
        if Kemal::Shield.config.oac
          context.response.headers["Origin-Agent-Cluster"] = "?1"
        end
        call_next(context)
      end
    end
  end
end
