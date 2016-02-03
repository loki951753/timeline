class WechatController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  #验证WeChat接口
  def show
    puts "get show"
    render :text => params[:echostr]
  end

  #处理微信服务器发来的消息
  def create
    puts "get create"
    @req = Hash.from_xml(request.raw_post).symbolize_keys[:xml]

    case @req["MsgType"]
    when "text"
      @req["msg_type"] = "text"
      @req["response_text"] = "功能正在开发当中，敬请期待..."
      render "res", formats: :xml
    when "event"
      @req["msg_type"] = "text"
      @req["response_text"] = "欢迎关注账号，这是发自开发者的一段代码"
      render "res", formats: :xml
    end
  end

  def menu
    puts 'get menu'
    access_token = $redis.get('access_token') || get_access_token

    
  end

  private
  def check_weixin_legality
    puts "get here1"
    array = [Rails.configuration.wechat_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def get_access_token
    puts 'get_access_token'
    require 'net/http'
    uri = URI("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{Rails.configuration.wechat_appid}&secret=#{Rails.configuration.wechat_appsecret}")
    res = Net::HTTP.get(uri)
    res = JSON.parse(res)

    $redis.set('access_token', res.access_token)
    $redis.set('access_token_expired_time', res.expires_in)

    res.access_token
  end
end