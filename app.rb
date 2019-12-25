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

# [START gae_flex_quickstart]
require "sinatra"
require 'sass'
require 'compass'
#require "google/cloud/storage"

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = File.join('views', 'stylesheets')
  end

  set :sass, Compass.sass_engine_options
end

# Google cloud storage stuff
#PROJECT_ID = "spozderwebsite"
#BUCKET_NAME = "spozderwebsite"

#storage = Google::Cloud::Storage.new(project_id: PROJECT_ID)
#bucket = storage.bucket(BUCKET_NAME)

# TODO: When on laptop again
#bucket.files.each do |file|
#	puts file.name	
#end	

get "/" do
  "Hello world!"
end

get "/countdown/ranch" do
	@countdown_to = "Jan 5, 2020 23:00:00"
	slim :countdown
end

get "/countdown" do
	@countdown_to = params[:date] || "Jan 5, 2020 23:00:00"	
  slim :countdown
end

get "/style/:name" do
  sass :"stylesheets/#{params[:name]}_stylesheet", Compass.sass_engine_options
end
# [END gae_flex_quickstart]
