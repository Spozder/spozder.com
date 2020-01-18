# Copyright 2015 Google, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gae_standard_quickstart]
require "sinatra"
require 'sass'
require 'compass'
require "google/cloud/storage"

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = File.join('views', 'stylesheets')
    config.cache_path = File.join('/tmp', '.sass-cache')
  end

  set :sass, Compass.sass_engine_options
end

# Google cloud storage stuff
PROJECT_ID = "spozderwebsite"
BUCKET_NAME = "spozderwebsite"

storage = Google::Cloud::Storage.new(project_id: PROJECT_ID)
bucket = storage.bucket(BUCKET_NAME)

all_backgrounds = bucket.files
compressed_backgrounds = bucket.files.select { |f| f.name.include?("compressed") }

background_hash = {
  rachel_v: compressed_backgrounds.select { |f| f.name.include?("/rvert") },
  rachel_h: compressed_backgrounds.select { |f| f.name.include?("/rhoriz") },
  v: all_backgrounds.select { |f| f.name.include?("/vert/") },
  h: all_backgrounds.select { |f| f.name.include?("/horiz/") }
}

get "/" do
  slim :home
end

get "/projects" do
  slim :projects
end

get "/resume" do
  slim :resume
end

get "/contact" do
  slim :contact
end

before do
  @background_images = {
    v: background_hash[:v].sample.public_url,
    h: background_hash[:h].sample.public_url
  }
  @background_style = "cover"
end

get "/countdown/ranch" do
  @background_images = {
    v: background_hash[:rachel_v].sample.public_url,
    h: background_hash[:rachel_h].sample.public_url
  }
  @background_style = "contain"
  @countdown_to = "Jan 20, 2020 23:00:00 EST"
  @message = "Hello :)"
	slim :countdown
end

get "/countdown" do
  if params[:datetime]
    @countdown_to = params[:datetime]
    if params[:message]
      @message = params[:message]
    end
    slim :countdown
  else
    slim :create_countdown
  end
end

get "/style/:name" do
  sass :"stylesheets/#{params[:name]}_stylesheet", Compass.sass_engine_options
end
# [END gae_standard_quickstart]
