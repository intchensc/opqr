# frozen_string_literal: true
require 'opqr'
# 加载插件
plugin_dir = File.join(File.dirname(__FILE__), 'plugins')
# p plugin_dir
ps = OPQ::PluginLoader.new
ps.load_all(plugin_dir)
# 必须是个数组
# 使用OPQ::QqObj.new创建需要监听消息的对象，加入对象数组ob
# 功能请在插件目录添加插件实现
ob = []
ob << OPQ::QqObj.new(1294222408,ps.plugins)
bot = OPQ::Bot.new("127.0.0.1",8086,ob)
bot.run

