# frozen_string_literal: true
require_relative '../../lib/opqr'
# 请使用下面加载依赖（上方请注释）
# require 'opqr'

# ctx结构如下
# @type
# @from_uin
# @sender_uin
# @text
# @msg_type
# @raw_json

class Dxx < OPQ::PluginBase
  attr_accessor :plugin_version,:plugin_name, :plugin_author,:plugin_dir, :plugin_allow_group
  def initialize
    # 插件所在目录，用于加载本地文件
    @plugin_dir = __dir__ + '/'
    # 插件信息，用于加载时在控制台输出
    @plugin_name = "测试插件"
    @plugin_version = "V1.0"
    @plugin_author = "圈哥"
    # 启用插件的群
    @plugin_allow_group = [435994283,415111732]
  end
  def receive_qq(qq, ctx)
    p "dxx插件在这里"
    # OPQ::Api.new.send_text_qq(941094692,"我现在发消息给你",qq)
    pics = []
    3.times do
      pics << "https://img1.bdstatic.com/static/common/img/baidu_image_logo_2dd9a28.png"
    end
    OPQ::Api.new.send_pic_qq_url(ctx.from_uin, qq, "发图测试",pics)
  end
  def receive_group(qq, ctx)
    p "dxx收到了来自群的消息"
    if ctx.text == "回我"
    OPQ::Api.new.send_text_group(ctx.from_uin,"我收到了你的消息",qq)
    pics = []
    3.times do
      pics << @plugin_dir + "../1.jpg"
    end
    OPQ::Api.new.send_pic_group_local(ctx.from_uin,qq,"测试群组发图",pics)
    end
  end
end
