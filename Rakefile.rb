require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Generate the Rdoc for GEM in the docs folder."
task :dokken do
  require 'fileutils'
  require 'rubygems'
  require 'rubygems/command'
  require 'rubygems/doc_manager'

  gem_name = ENV['GEM']
  raise "Must use GEM=" unless gem_name
  
  version = ENV['VERSION']

  specs = Gem::SourceIndex.from_installed_gems.find_name(gem_name, version)  
  current = specs.last

  Gem::DocManager.load_rdoc
  m = Gem::DocManager.new current
  m.run_rdoc '-o', File.join(File.dirname(__FILE__), 'docs', current.full_name)
end

desc "Clear all Rdocs from the docs folder."
task :undok do
  FileUtils.rm_rf(File.join(File.dirname(__FILE__), 'docs'))
end