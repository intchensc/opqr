# encoding=utf-8
require 'eventmachine'
require 'websocket-eventmachine-server'
module OPQ
  class WsServer
    def initialize(host, port, observer)
      @host = host
      @port = port
      @observer = observer
      self.start
    end
    def start
        EM.run do
          WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => @port, :mode => :async) do |ws|
            ws.onopen do
              puts "[WS] 连接已建立"
            end
            ws.onmessage do |msg, type|
              puts "[WS] 收到数据-->".force_encoding('UTF-8')+ "#{msg}".force_encoding('UTF-8')
              @observer.on_message_received(msg)
            end

            ws.onclose do
              puts "[WS] 连接已断开"
            end
          end
        end
    end
  end

end
