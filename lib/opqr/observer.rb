# encoding=utf-8
module OPQ
  class Observer
    def initialize(observers)
      @observers = observers
    end

    def add_observer(observer)
      @observers << observer
    end

    def remove_observer(observer)
      @observers.delete(observer)
    end

    def notify_observers(data)
      @observers.each { |observer| observer.on_data_received(data) }
    end

    def on_message_received(msg)
      j = JSON.parse(msg)
      if (msg_type = j['CurrentPacket']['EventData']['MsgHead']['MsgType'] != 732)
       notify_observers(msg)
      end
    end
  end
end