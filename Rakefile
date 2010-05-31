require "rake/testtask"

task :default => [:test]

Rake::TestTask.new do |task|
    task.libs << "lib"
    task.test_files = FileList["test/test*.rb"]
end
