# encoding=utf-8
require 'eventmachine'
require 'faye/websocket'
module OPQ
  class WsServer
    def initialize(observer)
      @observer = observer
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

    end
  end

end
