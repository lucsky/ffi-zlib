require "test/unit"

task :test do
    $LOAD_PATH << "lib"
    Dir[File.join("tests", "test_*.rb")].each { |t| require t }
end