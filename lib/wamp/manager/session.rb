# frozen_string_literal: true

require "forwardable"

module Wamp
  module Manager
    # handles session
    class Session
      extend Forwardable

      attr_reader :connection, :session_id

      def initialize(connection)
        @connection = connection
      end

      def session_id=(id)
        if session_id
          send_protocol_violation("Received WELCOME message after session was established")
        else
          @session_id = id
        end
      end

      def send_protocol_violation(text, *args, **kwargs)
        message = Message::Abort.new({ message: text }, "wamp.error.protocol_violation", *args, **kwargs)
        manager = Manager::Event::Abort.new(message, self)
        connection.transmit(message.payload)
        manager.emit_event(message)
      end

      def subscribe(topic, handler, options = {}, &block)
        message = Message::Subscribe.new(next_request_id, options, topic)
        manager = Manager::Event::Subscribe.new(message, self)
        manager.add_event_listener(handler, &block)
        manager.subscription
      end

      def unsubscribe(subscription_id, &block)
        message = Message::Unsubscribe.new(next_request_id, subscription_id)
        Subscription.new(message, self, subscription_id).unsubscribe(&block)
      end

      def publish(topic, options = {}, *args, **kwargs, &block)
        options = options.merge({ acknowledge: true }) if block_given?
        message = Message::Publish.new(next_request_id, options, topic, *args, **kwargs)
        Manager::Event::Publish.new(message, self).add_event_listener(&block)
      end

      def call(procedure, options = {}, *args, **kwargs, &block)
        message = Message::Call.new(next_request_id, options, procedure, *args, **kwargs)
        Manager::Event::Call.new(message, self).add_event_listener(&block)
      end

      def register(procedure, handler, options = {}, &block)
        message = Message::Register.new(next_request_id, options, procedure)
        Manager::Event::Register.new(message, self).add_event_listener(handler, &block)
      end

      def unregister(registration_id, &block)
        message = Message::Unregister.new(next_request_id, registration_id)
        Manager::Event::Unregister.new(message, self).add_event_listener(&block)
      end

      def on_message(message)
        manager = Manager::Event.resolve(message, self)
        manager.emit_event(message)
      end

      def create_request_id
        next_request_id
      end

      private

      def next_request_id
        @next_request_id = create_request_id_generator unless defined?(@next_request_id)
        @next_request_id.call
      end

      def create_request_id_generator
        request_id = 0
        -> { request_id += 1 }
      end

      def_delegators :@connection, :emit, :on, :close, :transmit, :my_listeners, :auth
      def_delegator :auth, :authenticate
      def_delegator :@connection, :remove_all_listeners, :off
    end
  end
end
