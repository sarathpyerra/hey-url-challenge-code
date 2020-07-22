# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :set_url , :only => [:visit,:show]
  def index
    @url = Url.new
    @urls = Url.latest.includes(:clicks)
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      flash[:notice]="Sucessfully created url" 
      redirect_to action: :index 
    else
      @urls = Url.all
      render action: :index 
    end
  end

  def show
    if @url.present?
      @daily_clicks = @url.get_daily_clicks
      @browsers_clicks = @url.get_browser_clicks
      @platform_clicks =@url.get_platform_clicks
    else
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found 
    end
  end

  def visit
    if @url.present?
      #Track user requests
      @browser = Browser.new(request.env["HTTP_USER_AGENT"])
      @url.track_browser_details(@browser)
      redirect_to @url.original_url
    else
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found 
    end
  end

  private
  def set_url 
    @url = Url.find_by_short_url(params[:url])
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
