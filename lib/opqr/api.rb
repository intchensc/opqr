# encoding=utf-8
require "uri"
require "json"
require "net/http"
module OPQ
  class Api
    def send_text_qq(to_qq, content, form_qq)
      url = URI("http://"+$api_url.to_s+":"+$http_port.to_s+"/v1/LuaApiCaller?funcname=MagicCgiCmd&timeout=10&qq="+form_qq.to_s)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["User-Agent"] = "Apifox/1.0.0 (https://www.apifox.cn)"
      request["Content-Type"] = "application/json"
      request.body = {
        "CgiCmd": "MessageSvc.PbSendMsg",
        "CgiRequest": {
          "ToUin": to_qq.to_i,
          "ToType": 1,
          "Content": content.to_s
        }
      }.to_json
      response = http.request(request)
      t = JSON.parse(response.read_body)
      # 发Q不显示失败
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[文字发Q] " +form_qq.to_s+"->"+to_qq.to_s+" 成功"
      else
        puts "[文字发Q] " +form_qq.to_s+"->"+to_qq.to_s+" " + t['CgiBaseResponse']['ErrMsg']
      end
    end

    def send_text_group(to_group, content, form_qq)
      url = URI("http://"+$api_url.to_s+":"+$http_port.to_s+"/v1/LuaApiCaller?funcname=MagicCgiCmd&timeout=10&qq="+form_qq.to_s)
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["User-Agent"] = "Apifox/1.0.0 (https://www.apifox.cn)"
      request["Content-Type"] = "application/json"
      request.body = {
        "CgiCmd": "MessageSvc.PbSendMsg",
        "CgiRequest": {
          "ToUin": to_group.to_i,
          "ToType": 2,
          "Content": content.to_s,
          "AtUinLists": [
            {
              "QQNick": "0.0",
              "QQUid": 941094692
            }
          ]
        }
      }.to_json
      response = http.request(request)
      t = JSON.parse(response.read_body)
      if t['CgiBaseResponse']['ErrMsg'].empty?
        puts "[文字发群] " +form_qq.to_s+"->"+to_group.to_s+" 成功"
      else
        puts "[文字发群] " +form_qq.to_s+"->"+to_group.to_s+" " + t['CgiBaseResponse']['ErrMsg']
      end
    end
    end
  # $api_url="127.0.0.1"
  # $http_port=8086
  # Api.new.send_text_qq(941094692,"sb",1294222408)
  # Api.new.send_text_group(435994283,"d",1294222408)
end