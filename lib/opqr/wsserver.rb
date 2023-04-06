# encoding=utf-8
require 'eventmachine'
require 'websocket-eventmachine-server'
require 'faye/websocket'
module OPQ
  class WsServer
    def initialize(observer)
      @observer = observer
      self.start
    end
    def start
      EM.run {
        ws = Faye::WebSocket::Client.new('ws://'+$api_url.to_s+':'+$http_port.to_s+'/ws')
        ws.on :open do |event|
          puts "[WS] 连接已建立"
        end

        ws.on :message do |event|
          puts "[WS] 收到数据-->".force_encoding('UTF-8')+ "#{event.data}".force_encoding('UTF-8')
          @observer.on_message_received(event.data)
        end

        ws.on :close do |event|
          puts "[WS] 连接已断开"
          ws = nil
        end
      }
        # EM.run do
        #   WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => @port, :mode => :async) do |ws|
        #     ws.onopen do
        #       puts "[WS] 连接已建立"
        #     end
        #     ws.onmessage do |msg, type|
        #       puts "[WS] 收到数据-->".force_encoding('UTF-8')+ "#{msg}".force_encoding('UTF-8')
        #       @observer.on_message_received(msg)
        #     end
        #
        #     ws.onclose do
        #       puts "[WS] 连接已断开"
        #     end
        #   end
        # end
    end
  end

end
