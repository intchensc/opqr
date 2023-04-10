# encoding=utf-8
require "uri"
require "json"
require "net/http"
module OPQ
  class Api
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
    def base_upload(to_type, path, from_qq)
      url = URI("http://"+$api_url.to_s+":"+$http_port.to_s+"/v1/upload?qq="+from_qq.to_s)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["User-Agent"] = "Apifox/1.0.0 (https://www.apifox.cn)"
      request["Content-Type"] = "application/json"
      request.body = {
        "CgiCmd": "PicUp.DataUp",
        "CgiRequest": {
          "CommandId": to_type.to_i,
          "FileUrl": path.to_s
        }
      }.to_json
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
          t = base_upload(1,p, from_qq)
          if t['CgiBaseResponse']['ErrMsg'].empty?
            puts "[图片上传] " + from_qq.to_s + "->" + p.to_s + "成功"
            pics << t['ResponseData']
          else
            puts "[图片上传] " + from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
          end
        end
      elsif path.is_a?(String)
        t = base_upload(1,path, from_qq)
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
          t = base_upload(2,p, from_qq)
          if t['CgiBaseResponse']['ErrMsg'].empty?
            puts "[图片上传] " + from_qq.to_s + "->" + p.to_s + "成功"
            pics << t['ResponseData']
          else
            puts "[图片上传] " + from_qq.to_s+"->"+t['CgiBaseResponse']['ErrMsg']
          end
        end
      elsif path.is_a?(String)
        t = base_upload(2,path, from_qq)
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
  end
end