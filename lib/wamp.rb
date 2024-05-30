# frozen_string_literal: true

require_relative "wamp/version"
require_relative "wamp/message_handler"
require_relative "wamp/connection/session"
require_relative "wamp/connection/websocket_connection"
require_relative "wamp/serializer"
require_relative "wamp/router"

module Wamp
  class Error < StandardError; end
  # Your code goes here...
end
