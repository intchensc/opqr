# encoding=utf-8
require_relative 'observer'
require_relative 'wsserver'
require_relative 'api'
module OPQ
  class Bot
    attr_accessor :observer, :ws
    def initialize(api_url, http_port, websocket_port, observers)
      $http_port = http_port
      $websocket_port = websocket_port
      $api_url = api_url
      @observer = Observer.new(observers)
      puts "[BOT] 正在尝试连接WS，请稍等~"
      @ws = WsServer.new(api_url,websocket_port, @observer)
    end
  end
end