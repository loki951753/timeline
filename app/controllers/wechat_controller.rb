class WechatController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality

  def show
    puts "get show"
    render :text => params[:echostr]
  end

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

  private
  def check_weixin_legality
    puts "get here1"
    array = [Rails.configuration.wechat_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end