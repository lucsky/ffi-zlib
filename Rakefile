require "rubygems"
require 'rake/gempackagetask'

load 'ffi-zlib.gemspec'

Rake::GemPackageTask.new($spec) do |p|
  p.need_tar = true
  p.need_zip = true
end

task :test do
    require "test/unit"
    $LOAD_PATH << "lib"
    Dir[File.join("tests", "test_*.rb")].each { |t| require t }
end

task :default => :package