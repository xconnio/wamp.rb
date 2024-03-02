# frozen_string_literal: true

module Wamp
  module Manager
    # connection
    class Connection < Connection::Base
      attr_reader :session

      def initialize(*args)
        super
        @session = Session.new(self)
      end

      def on_message(data)
        message = Message.resolve(coder.decode(data))
        if message.instance_of? Message::Welcome

          event_manager = Manager::Event.resolve(message, session)
          event_manager.emit_event(message)
        else
          session.on_message(message)
        end
      end

      def on_open
        send_hello_message
      end

      private

      def send_hello_message
        message = Message::Hello.new(@realm)
        manager = Manager::Event::Hello.new(message, self)
        manager.add_event_listener # adds on :join event listener
      end
    end
  end
end
