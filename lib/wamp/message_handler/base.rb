# frozen_string_literal: true

require "forwardable"

module Wamp
  module MessageHandler
    # Result
    class Base
      extend Forwardable
      attr_reader :message, :connection

      def initialize(message, connection)
        @message = message
        @connection = connection
      end

      def stored_data
        @stored_data ||= store.delete(store_key) || {}
      end

      def store_key
        "#{prefix}_#{identity}"
      end

      def prefix
        "request"
      end

      def identity
        message.request_id
      end

      def handle
        raise NotImplementedError
      end

      def send_message
        raise NotImplementedError
      end

      def deliver_response
        callback = stored_data.fetch(:callback, proc {})
        return unless callback

        callback.call(message)
      end

      def send_serialized(message)
        connection.transmit session.send_message(message)
      end

      def_delegators :@connection, :store, :joiner, :session
      # def_delegator :auth, :authenticate
      # def_delegator :@connection, :remove_all_listeners, :off
    end
  end
end
