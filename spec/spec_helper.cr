require "spec"
require "../src/kemal-shield"

# credit to: https://github.com/kemalcr/kemal/blob/master/spec/spec_helper.cr#L58

def call_request_on_app(request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  main_handler = build_main_handler
  main_handler.call(context)
  response.close
  io.rewind
  HTTP::Client::Response.from_io(io, decompress: false)
end

def build_main_handler
  Kemal.config.setup
  main_handler = Kemal.config.handlers.first
  current_handler = main_handler
  Kemal.config.handlers.each do |handler|
    current_handler.next = handler
    current_handler = handler
  end
  main_handler
end

Spec.after_each do
  Kemal.config.clear
  Kemal::RouteHandler::INSTANCE.routes = Radix::Tree(Kemal::Route).new
end
