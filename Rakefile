require "rubygems"
require "test/unit"

task :gem => [:clean] do
    system "gem build ffi-zlib.gemspec"
end

task :clean do
    Dir["ffi-zlib-*.gem"].each { |f| File.delete(f) }
end

task :test do
    $LOAD_PATH << "lib"
    Dir[File.join("tests", "test_*.rb")].each { |t| require t }
end