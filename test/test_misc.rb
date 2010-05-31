require "test/unit"
require "ffi/zlib"
require "test/helper.rb"

class TestMisc < Test::Unit::TestCase
    
    def test_version
        assert_not_nil FFI::Zlib.zlibVersion
    end
    
    def test_compile_flags
        assert_not_equal FFI::Zlib.zlibCompileFlags, 0
    end
    
    def test_crc_table
        table = FFI::Zlib.get_crc_table
        assert_not_nil table
    end
    
    def test_errors
        do_test_error FFI::Zlib::Z_OK
        do_test_error FFI::Zlib::Z_STREAM_END
        do_test_error FFI::Zlib::Z_NEED_DICT
        do_test_error FFI::Zlib::Z_ERRNO
        do_test_error FFI::Zlib::Z_STREAM_ERROR
        do_test_error FFI::Zlib::Z_DATA_ERROR
        do_test_error FFI::Zlib::Z_MEM_ERROR
        do_test_error FFI::Zlib::Z_BUF_ERROR
        do_test_error FFI::Zlib::Z_VERSION_ERROR
    end
    
    def do_test_error(err)
        err_str = FFI::Zlib.zError(err)
        assert_not_nil err_str
        assert_instance_of String, err_str
    end
    
end