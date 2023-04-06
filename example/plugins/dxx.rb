# frozen_string_literal: true
require 'opqr'
# ctx结构如下
# @type
# @from_uin
# @sender_uin
# @text
# @msg_type
# @raw_json

class Dxx < OPQ::PluginBase
  def receive_qq(qq, ctx)
    p "dxx收到来自好友的消息"
    OPQ::Api.new.send_text_qq(941094692,"我现在发消息给你",qq)
  end
  def receive_group(qq, ctx)
    p "dxx收到了来自群的消息"
    if ctx.text == "回我"
    OPQ::Api.new.send_text_group(435994283,"我收到了你的消息",qq)
    end
  end
end
