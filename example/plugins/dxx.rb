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
    # OPQ::Api.new.send_text_qq(941094692,"我现在发消息给你",qq)
    pics = []
    3.times do
      pics << "https://img1.bdstatic.com/static/common/img/baidu_image_logo_2dd9a28.png"
    end
    OPQ::Api.new.send_pic_qq_url(941094692, qq, "发图测试",pics)
  end
  def receive_group(qq, ctx)
    p "dxx收到了来自群的消息"
    if ctx.text == "回我"
    OPQ::Api.new.send_text_group(435994283,"我收到了你的消息",qq)
    pics = []
    3.times do
      pics << "https://img1.bdstatic.com/static/common/img/baidu_image_logo_2dd9a28.png"
    end
    OPQ::Api.new.send_pic_group_url(435994283,qq,"测试群组发图",pics)
    end
  end
end
