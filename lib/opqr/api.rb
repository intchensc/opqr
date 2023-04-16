# encoding=utf-8
require "uri"
require "json"
require "net/http"
require 'base64'
module OPQ
  class Api
    # 本地文件base64编码
    def img_to_base64(file_path)
      # 读取本地图片文件
      image = File.open(file_path).binmode
      image_read = image.read
      image_64_encode = Base64.encode64(image_read)
    end
    # 发消息基础API
    def base_api(from_qq, to_uin, to_type, content, image_list:[{}])
      body =
        {
          "CgiCmd":"MessageSvc.PbSendMsg",
          "CgiRequest":{
            "ToUin":to_uin.to_i,
            "ToType":to_type.to_i,
            "Content":content.to_s,
            "Images":image_list,
          }
        }
      url = URI("http://"+$api_url.to_s+":"+$http_port.to_s+"/v1/LuaApiCaller?funcname=MagicCgiCmd&timeout=10&qq="+from_qq.to_s)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["User-Agent"] = "Apifox/1.0.0 (https://www.apifox.cn)"
      request["Content-Type"] = "application/json"
      request.body = body.to_json
      response = http.request(request)
      t = JSON.parse(response.read_body)
      t
    end
    # 资源上传API
    def base_upload(to_type,upload_type,file_path, from_qq)
      url = URI("http://"+$api_url.to_s+":"+$http_port.to_s+"/v1/upload?qq="+from_qq.to_s)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["User-Agent"] = "Apifox/1.0.0 (https://www.apifox.cn)"
      request["Content-Type"] = "application/json"
      body = {
        "CgiCmd": "PicUp.DataUp",
        "CgiRequest": {
          "CommandId": to_type.to_i,
        }
      }
      if upload_type == 1
        body[:CgiRequest][:FileUrl] = file_path
      elsif upload_type == 2
        body[:CgiRequest][:Base64Buf] = img_to_base64(file_path)
      end
      request.body = body.to_json
      response = http.request(request)
      t = JSON.parse(response.read_body)
    end
    def send_text_qq(to_qq, content, from_qq)
      t = self.base_api(from_qq, to_qq, 1, content)
      # 发Q不显示失败
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[文字发Q] "+from_qq.to_s+ "->" +to_qq.to_s+" 成功"
      else
        puts "[文字发Q] "+ from_qq.to_s+ "->"+to_qq.to_s+" "+t['CgiBaseResponse']['ErrMsg']
      end
    end
    def send_text_group(to_group, content, from_qq)
      t = self.base_api(from_qq, to_group, 2, content)
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[文字发群] "+from_qq.to_s+"->",to_group.to_s+"成功"
      else
        puts "[文字发群] "+from_qq.to_s+"->"+to_group.to_s+ t['CgiBaseResponse']['ErrMsg']
      end
    end
    def send_pic_qq_url(to_qq,from_qq,content, path)
      pics = []
      if path.is_a?(Array)
        path.each do |p|
          t = base_upload(1,1,p, from_qq)
          if t['CgiBaseResponse']['ErrMsg'].empty?
            puts "[图片上传] " + from_qq.to_s + "->" + p.to_s + "成功"
            pics << t['ResponseData']
          else
            puts "[图片上传] " + from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
          end
        end
      elsif path.is_a?(String)
        t = base_upload(1,1,path, from_qq)
        if t['CgiBaseResponse']['ErrMsg'].empty?
          puts "[图片上传] "+from_qq.to_s+"->"+path.to_s,"成功"
          pics << t['ResponseData']
        else
          puts "[图片上传] "+from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
        end
      end
      t = base_api(from_qq,to_qq,1,content,image_list:pics)
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[URL图片发Q] "+ from_qq.to_s+ "->"+to_qq.to_s+" 成功"
      else
        puts "[URL图片发Q] "+from_qq.to_s+ "->"+to_qq.to_s+" "+t['CgiBaseResponse']['ErrMsg']
      end
    end
    def send_pic_group_url(to_qq, from_qq, content, path)
      pics = []
      if path.is_a?(Array)
        path.each do |p|
          t = base_upload(2,1,p, from_qq)
          if t['CgiBaseResponse']['ErrMsg'].empty?
            puts "[图片上传] " + from_qq.to_s + "->" + p.to_s + "成功"
            pics << t['ResponseData']
          else
            puts "[图片上传] " + from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
          end
        end
      elsif path.is_a?(String)
        t = base_upload(2,1,path, from_qq)
        if t['CgiBaseResponse']['ErrMsg'].empty?
          puts "[图片上传] "+from_qq.to_s+"->"+path.to_s,"成功"
          pics << t['ResponseData']
        else
          puts "[图片上传] "+from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
        end
      end
      t = base_api(from_qq,to_qq,2,content,image_list:pics)
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[URL图片发Q] "+ from_qq.to_s+ "->"+to_qq.to_s+" 成功"
      else
        puts "[URL图片发Q] "+from_qq.to_s+ "->"+to_qq.to_s+" "+t['CgiBaseResponse']['ErrMsg']
      end
    end
    def send_pic_qq_local(to_qq,from_qq,content, path)
      pics = []
      if path.is_a?(Array)
        path.each do |p|
          t = base_upload(1,2,p, from_qq)
          if t['CgiBaseResponse']['ErrMsg'].empty?
            puts "[图片上传] " + from_qq.to_s + "->" + p.to_s + "成功"
            pics << t['ResponseData']
          else
            puts "[图片上传] " + from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
          end
        end
      elsif path.is_a?(String)
        t = base_upload(1,2,path, from_qq)
        if t['CgiBaseResponse']['ErrMsg'].empty?
          puts "[图片上传] "+from_qq.to_s+"->"+path.to_s,"成功"
          pics << t['ResponseData']
        else
          puts "[图片上传] "+from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
        end
      end
      t = base_api(from_qq,to_qq,1,content,image_list:pics)
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[URL图片发Q] "+ from_qq.to_s+ "->"+to_qq.to_s+" 成功"
      else
        puts "[URL图片发Q] "+from_qq.to_s+ "->"+to_qq.to_s+" "+t['CgiBaseResponse']['ErrMsg']
      end
    end
    def send_pic_group_local(to_qq, from_qq, content, path)
      pics = []
      if path.is_a?(Array)
        path.each do |p|
          t = base_upload(2,2,p, from_qq)
          if t['CgiBaseResponse']['ErrMsg'].empty?
            puts "[图片上传] " + from_qq.to_s + "->" + p.to_s + "成功"
            pics << t['ResponseData']
          else
            puts "[图片上传] " + from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
          end
        end
      elsif path.is_a?(String)
        t = base_upload(2,2,path, from_qq)
        if t['CgiBaseResponse']['ErrMsg'].empty?
          puts "[图片上传] "+from_qq.to_s+"->"+path.to_s,"成功"
          pics << t['ResponseData']
        else
          puts "[图片上传] "+from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
        end
      end
      t = base_api(from_qq,to_qq,2,content,image_list:pics)
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[本地图片发Q] "+ from_qq.to_s+ "->"+to_qq.to_s+" 成功"
      else
        puts "[本地图片发Q] "+from_qq.to_s+ "->"+to_qq.to_s+" "+t['CgiBaseResponse']['ErrMsg']
      end
    end
  end
end