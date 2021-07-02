require "kemal"

class Kemal::Shield::ExpectCT < Kemal::Handler
  @max_age : Int32
  @enforce : Bool
  @report_uri : String

  def initialize(@max_age = 0, @enforce = false, @report_uri = "")
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
