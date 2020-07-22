# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is an invalid URL' do
      invalid_urls = ['gogge.com','glass.com', 'testing','not a url']
      invalid_urls.each do |url|
        url = Url.create(:original_url => url )
        expect(url).to be_invalid
        expect(url.errors[:original_url].size).to eq(1)
      end
    end

    it 'validates original URL is an valid URL' do
      invalid_urls = ['https://gogge.com','http://glass.com', 'http://testing.net/asdasd/asdasd']
      invalid_urls.each do |url|
        url = Url.create(:original_url => url )
        expect(url).to be_valid
        expect(url.errors[:original_url].size).to eq(0)
      end
    end
  end
end
