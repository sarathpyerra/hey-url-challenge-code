# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      url = "https://www.google.com/"
      for i in 1..12
       Url.create({:original_url => "#{url}+#{i}"})
      end
    end

    it 'shows the latest 10 URLs' do
      get :index
      expect(assigns(:urls).size).to eq(10)
    end
  end

  describe 'POST #create' do
    it 'creates a new url' do
      post :create , :params => { :url => {:original_url => "https://testing123.com"}}
      expect(response).to redirect_to :action => :index
    end
  end

  describe 'GET #show' do
    before(:each) do
      @url = Url.create({:original_url => "https://www.google.com/"})
      @url.clicks.create({browser: "chrome",
      platform: 'windows'})
    end
    it 'shows stats about the given URL' do
      get :show, :params => {:url => @url.short_url}
      expect(assigns(:browsers_clicks).size).to eq(1)
      expect(assigns(:platform_clicks).size).to eq(1)
    end

    it 'throws 404 when the URL is not found' do
      get :show, :params => {:url => 'asdasdsa' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #visit' do
    before(:each) do
      @url = Url.create({:original_url => "https://www.google.com/"})
    end
    it 'tracks click event and stores platform and browser information' do
      get :visit, :params => {:url => @url.short_url }
      expect(@url.clicks.count).to eq(1)
      expect(@url.clicks.first[:browser]).to be
      expect(@url.clicks.first[:platform]).to be
    end

    it 'redirects to the original url' do
      get :visit, :params => {:url => @url.short_url }
      expect(response).to redirect_to @url.original_url
    end

    it 'throws 404 when the URL is not found' do
      get :visit, :params => {:url => 'asdasdsa' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
