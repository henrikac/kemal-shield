require "kemal"

class Kemal::Shield::XPermittedCrossDomainPolicies < Kemal::Handler
  def call(context)
    policies = Kemal::Shield.config.x_permitted_cross_domain_policies
    context.response.headers["X-Permitted-Cross-Domain-Policies"] = policies
    call_next(context)
  end
end
