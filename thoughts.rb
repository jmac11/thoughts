require 'rubygems'
require 'sinatra'

%w[sequel maruku splam splam/rule splam/rules openid].each do |prereq|
  $LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/#{prereq}/lib"
  require prereq
end

$LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/rack-openid/lib"
require "rack/openid"

$LOAD_PATH.unshift File.dirname(__FILE__) + "/vendor/sinatra-cache/lib"
require "sinatra/cache"

require "builder"

configure :test do
  db = Sequel::DATABASES.first || Sequel.connect('sqlite:/')
  
  require 'sequel/extensions/migration'
  Sequel::Migrator.apply(db, 'db/migrations', 0, nil)
  Sequel::Migrator.apply(db, 'db/migrations')
  db[:blogs].insert(:title =>'my test blog', :tagline => 'testing 1,2,3', :theme => 'default', :domain => 'http://test.com')
end

configure :production, :development do
  logger = Logger.new("log/#{Sinatra::Application.environment}.log")
  Sequel.connect('sqlite://db/blog.db',:loggers => [logger])
  set :logging, false
  set :logger, logger
  use Rack::CommonLogger, logger
end

configure do

  %w[blog post comment tag tagging user].each do |model|
    require "models/#{model}"
  end
  
  if Blog.default
    set :public, 'themes/' + Blog.default.theme + '/public'
    set :views, 'themes/' + Blog.default.theme + '/views'
  end
  
  enable :sessions
  set :cache_enabled, true
  set :cache_output_dir, 'cache'
  use Rack::OpenID
                              
  require "sequel/extensions/pagination"
  
end

layout 'layout'
load 'controllers/helpers.rb'
load 'controllers/admin_routes.rb'
load 'controllers/blog_routes.rb'