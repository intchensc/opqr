# encoding=utf-8
require 'json'
require_relative 'struct'
module OPQ
  class QqObj
    attr_accessor :plugins, :qq
    def initialize(qq, plugins)
      @qq = qq
      @plugins = plugins
    end
    def on_data_received(msg)
      msg_json = JSON.parse(msg)
      receive = OPQ::Msg.new(msg_json)
      @plugins.each do |p|
        # 1好友 2群组
        if receive.type == 1
          p.receive_qq(@qq, receive)
        elsif receive.type == 2 && receive.sender_uin != @qq && receive.msg_type != 732 && p.plugin_allow_group.include?(receive.from_uin)
          p.receive_group(@qq, receive)
        end
      end
    end
  end
end