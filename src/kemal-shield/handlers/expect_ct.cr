require "kemal"

# `Kemal::Shield::ExpectCT` is a handler that sets the Expect-CT HTTP header.
# This header tells browsers to expect Certificate Transparency.
#
# The default value is "max-age=0"
#
# The Expect-CT header can be updated by changing the values of
# ```
# Kemal::Shield.config.expect_ct_max_age
# Kemal::Shield.config.expect_ct_enforce
# Kemal::Shield.config.expect_ct_report_uri
# ```
#
# This handler can be turned off by setting
# ```
# Kemal::Shield.config.expect_ct = false
# ```
class Kemal::Shield::ExpectCT < Kemal::Handler
  @max_age : Int32
  @enforce : Bool
  @report_uri : String

  def initialize
    @max_age = Kemal::Shield.config.expect_ct_max_age
    @enforce = Kemal::Shield.config.expect_ct_enforce
    @report_uri = Kemal::Shield.config.expect_ct_report_uri

    if @max_age < 0
      raise ArgumentError.new("Expect-CT max-age must be greater than or equal to 0")
    end
  end

  def call(context)
    if Kemal::Shield.config.expect_ct
      value = "max-age=#{@max_age}"
      if @enforce
        value += ", enforce"
      end
      if !@report_uri.empty?
        value += ", report-uri=#{@report_uri}"
      end
      context.response.headers["Expect-CT"] = value
    end
    call_next(context)
  end
end
