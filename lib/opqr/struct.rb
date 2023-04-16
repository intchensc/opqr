# encoding=utf-8
module OPQ
  class Msg
    def initialize(msg)
      @type = msg['CurrentPacket']['EventData']['MsgHead']['FromType']
      @from_uin = msg['CurrentPacket']['EventData']['MsgHead']['FromUin']
      @sender_uin = msg['CurrentPacket']['EventData']['MsgHead']['SenderUin']
      @text = msg.fetch('CurrentPacket', {})
                  .fetch('EventData', {})
                  .fetch('MsgBody', {})
                  .fetch('Content', {})
      @msg_type = msg['CurrentPacket']['EventData']['MsgHead']['MsgType']
      @raw_json = msg
    end
    attr_accessor :type,:from_uin,:sender_uin,:text,:msg_type,:raw_json
  end
end