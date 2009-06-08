require 'rubygems'
require 'sinatra'
require 'erb'

set :app_file, __FILE__
set :reload, true
set :static, true

def dokked_gems
  @@dokked_gems = Dir.glob(File.join(File.dirname(__FILE__), 'docs', '**'))
  @@multiple = (@@dokked_gems.size > 1)
  @@dokked_gems
end

# If only one gem is RDoc'ed in the docs dir, it will be served from '/'.
# If multiple gems are in the docs dir, they will be served from their individual paths.
def unless_dokked(default)
  gems = dokked_gems
  if gems.size == 1
    gems.first
  else
    default
  end
end

set :root, unless_dokked(File.dirname(__FILE__))
set :public, unless_dokked(File.join(File.dirname(__FILE__), "docs"))

get '/:gem_name/' do
  serve_gems
end

get '/:gem_name' do
  serve_gems
end

def serve_gems
  gems = dokked_gems.collect { |g| File.basename(g) }

  if gems.include?(params[:gem_name])
    redirect "/#{params[:gem_name]}/index.html" 
  else
    raise Sinatra::NotFound
  end
end

get '/' do
  if @@multiple
    @dokked_gems = @@dokked_gems
    erb :index, :layout => :html
  else
    redirect "/index.html"
  end
end
