Gem::Specification.new do |s|
    s.name              = "ffi-zlib"
    s.version           = "0.1.0"
    s.platform          = Gem::Platform::RUBY
    s.summary           = "FFI based wrapper for zlib."
    s.homepage          = "http://github.com/lucsky/ffi-zlib/tree/master"

    s.description       = "ffi-zlib provides a very thin wrapper around zlib using the ruby ffi library."

    s.author            = "Luc Heinrich"
    s.email             = "luc@honk-honk.com"

    files = `git ls-files`.split("\n")
    files.delete('.gitignore')
        
    s.files             = files
    s.test_files        = Dir['tests/test_*.rb']
    s.require_path      = "lib"
    s.has_rdoc          = false

    s.add_dependency("ffi")
end
