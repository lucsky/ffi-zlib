$spec = Gem::Specification.new do |s|
    s.name              = "ffi-zlib"
    s.version           = "0.1.0"
    s.summary           = "FFI based wrapper for zlib."
    s.homepage          = "http://github.com/lucsky/ffi-zlib/tree/master"
    s.description       = "ffi-zlib provides a very thin wrapper around zlib using the ruby ffi library."
    s.platform          = Gem::Platform::RUBY

    s.author            = "Luc Heinrich"
    s.email             = "luc@honk-honk.com"
    s.rubyforge_project = "ffi-zlib"

    s.require_path      = "lib"
    s.has_rdoc          = false
    s.test_files        = %w( tests/test_checksums.rb
                              tests/test_compress.rb
                              tests/test_deflate.rb
                              tests/test_gz.rb
                              tests/test_misc.rb )
    s.files             = %w( README.mdown
                              Rakefile
                              ffi-zlib.gemspec
                              lib/ffi/zlib.rb
                              tests/helper.rb
                              tests/support/pale_blue_dot.txt ) + s.test_files

    s.add_dependency("ffi")
end
