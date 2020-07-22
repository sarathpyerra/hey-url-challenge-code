# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  before(:each) do
    @url= Url.create({:original_url => "https://www.google.com/"})
    @browser="browser" 
    @platform="platform" 
  end
  describe 'validations' do
    it 'validates url_id is invalid' do
      c = Click.create(:browser => @browser , :platform => @platform)
      expect(c).to be_invalid
    end

    it 'validates url_id is valid' do
      c = Click.create(:browser => @browser , :platform => @platform, :url_id => @url.id)
      expect(c).to be_valid
    end

    it 'validates browser is not null' do
      c = Click.create(:platform => @platform, :url_id => @url.id)
      expect(c.errors[:browser].size).to eq(1)
    end

    it 'validates platform is not null' do
      c = Click.create(:browser => @browser , :url_id => @url.id)
      expect(c.errors[:platform].size).to eq(1)
    end
  end
end
