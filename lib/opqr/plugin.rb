# encoding=utf-8
# frozen_string_literal: true
module OPQ
  class PluginBase
    attr_accessor :plugin_dir
    def receive_qq(qq, msg) ;end
    def receive_group(qq, msg);end
  end
  class PluginLoader
    attr_accessor :plugins
    def load_all(plugin_dir)
      puts "[BOT] 正在加载插件，请稍等~"
      @plugins = []
      Dir.glob(File.join(plugin_dir, '*.rb')).each do |plugin_file|
        $LOAD_PATH.unshift(plugin_dir)
        Kernel.load(plugin_file)
        plugin_name = File.basename(plugin_file, '.rb').capitalize
        plugin_class = Object.const_get("#{plugin_name}")
        @plugins << plugin_class.new
      end
      puts "[BOT] 插件加载完毕！"
      row = []
      @plugins.map do |p|
        row << [p.plugin_name, p.plugin_version, p.plugin_author]
      end
      table = Terminal::Table.new(:title => "插件列表",:headings=>["名称","版本","作者"],:rows=>row )
      puts table
    end
  end
end
