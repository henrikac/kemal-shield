require "kemal"

class Kemal::Shield::OriginAgentCluster < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.origin_agent_cluster
      context.response.headers["Origin-Agent-Cluster"] = "?1"
    end
    call_next(context)
  end
end
