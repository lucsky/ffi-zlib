require "date"

spec = Gem::Specification.new do |s|
    s.name              = "ffi-zlib"
    s.version           = "0.1.0"
    s.summary           = "FFI based wrapper for zlib."
    s.description       = "ffi-zlib provides a very thin wrapper around zlib using the Ruby FFI library."
    s.homepage          = "http://github.com/lucsky/ffi-zlib"
    s.platform          = Gem::Platform::RUBY

    s.author            = "Luc Heinrich"
    s.email             = "luc@honk-honk.com"

    s.require_path      = "lib"
    s.has_rdoc          = false
    s.test_files        = Dir["test/**/test_*.rb"]
    s.files             = Dir["lib/**/*"] + Dir["test/fixtures/*"] + ["README.md", "LICENSE"] + s.test_files

    s.add_dependency("ffi")
end
