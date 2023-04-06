# encoding=utf-8
# frozen_string_literal: true
module OPQ
  class PluginBase
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
      puts "[BOT] 插件加载完毕！" + @plugins.map { |p| p.class.name}.to_s
    end

  end
end
