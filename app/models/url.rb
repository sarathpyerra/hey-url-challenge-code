# frozen_string_literal: true
require 'uri'

class Url < ApplicationRecord
  scope :latest, -> {order('id DESC').limit(10)}
  validates :original_url, presence: true
  validates_format_of :original_url, :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  before_create :generate_short_url
  has_many :clicks ,dependent: :destroy

  def track_browser_details(browser)
    # This can be a background JOB 
    params = {
      browser: browser.name,
      platform: browser.platform
    }
    self.clicks.create(params)
  end

  #TODO Refactor all these methods so we can pass variables
  def get_daily_clicks
    self.clicks.select(:id, :created_at).group_by {|c| c.created_at.to_date }.collect{ |date,c| ["#{date}" , c.count] }
  end

  def get_browser_clicks
    #This can be moved to scopes 
    self.clicks.select(:id, :browser).group(:browser).pluck("browser, count(browser)")
  end

  def get_platform_clicks
    self.clicks.select(:id, :platform).group(:platform).pluck("platform, count(platform)")
  end

  def clicks_count
    self.clicks.count
  end

  private 
  def generate_short_url
    self.short_url = SecureRandom.urlsafe_base64[0..5]
  end
end
