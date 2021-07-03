require "kemal"

# `Kemal::Shield::XPermittedCrossDomainPolicies` is a handler that sets the
# X-Permitted-Cross-Domain-Policies HTTP header.
#
# X-Permitted-Cross-Domain-Policies specifies your domain's policies
# for loading cross-domain content.
#
# This handler sets the X-Permitted-Cross-Domain-Policies header to "none" by default.
#
# Valid options for this header:
# ```
# "none"
# "master-only"
# "by-content-type"
# "all"
# ```
#
# The X-Permitted-Cross-Domain-Polices header can be updated by changing
# the value of:
# ```
# Kemal::Shield.config.x_permitted_cross_domain_policies
# ```
#
# This handler can be turned off by setting
# ```
# Kemal::Shield.config.x_permitted_cross_domain_policies_on = false
# ```
class Kemal::Shield::XPermittedCrossDomainPolicies < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.x_permitted_cross_domain_policies_on
      policies = Kemal::Shield.config.x_permitted_cross_domain_policies
      context.response.headers["X-Permitted-Cross-Domain-Policies"] = policies
    end
    call_next(context)
  end
end
