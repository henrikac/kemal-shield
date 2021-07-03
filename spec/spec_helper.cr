require "spec"
require "../src/kemal-shield"

def process_request(request, handler)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  handler.call(context)
  response.close
  io.rewind
  io
end

# credit to: https://github.com/kemalcr/kemal/blob/master/spec/spec_helper.cr#L58

def call_request_on_app(request)
  io_with_context = process_request(request, build_main_handler)
  HTTP::Client::Response.from_io(io_with_context, decompress: false)
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
