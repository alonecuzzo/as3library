class SwfBaseController < ApplicationController

  before_filter :check_request_type, :build_address, :set_swfaddress_for_optimizer, :set_swfaddress_title

  layout :guess_layout

  protected

  def check_request_type
    return seo_request if request.content_type == 'application/x-swfaddress' 
  end

  def guess_layout
    swf_request? ? false : 'main'
  end

  def swf_request?
    params[:swf]
  end

  def seo_request
    qs = request.env['QUERY_STRING']
    session[:swfaddress] = qs
    if qs == '/'
      render :text => ''
    else
      render :text => "location.replace('/##{qs}')"
    end
  end

  def swfaddress
    @swfaddress ||= build_address
  end

  def build_address
    unless session[:swfaddress].blank?
      returning session[:swfaddress] do 
        session[:swfaddress] = nil
      end
    else
      request.env['REQUEST_URI'].sub(/([^\/])(\?|$)/, "\\1/\\2")
    end
  end

  def set_swfaddress_title
    title_path =  swfaddress.scan(/([^\/]+)\//).collect{|word| word[0].titleize}.join(" / ")
    @title = "SWFAddress Website" + (swfaddress == "/" ? "" : " / " + title_path)
  end

  def set_swfaddress_for_optimizer
    @optimizer_swfaddress = CGI.escape(swfaddress)
  end

end
