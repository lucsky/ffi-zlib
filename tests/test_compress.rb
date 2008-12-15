require "test/unit"
require "ffi/zlib"
require "tests/helper.rb"

class TestCompress < Test::Unit::TestCase
    include Setup
    
    def test_compress
        do_test

        s1 = do_test(FFI::Zlib::Z_NO_COMPRESSION)
        s2 = do_test(FFI::Zlib::Z_BEST_SPEED)
        s3 = do_test(FFI::Zlib::Z_DEFAULT_COMPRESSION)
        s4 = do_test(FFI::Zlib::Z_BEST_COMPRESSION)
        
        assert s1 > s2
        assert s2 > s3
        assert s3 >= s4
    end
    
    def do_test(level=nil)
        @buffer.put_string(0, @data)

        buffer_size = FFI::Zlib.compressBound(@data.length)
        assert_not_equal buffer_size, 0

        compressed_buffer_size = FFI::Buffer.alloc_inout(:ulong).put_ulong(0, buffer_size)
        compressed_buffer = FFI::MemoryPointer.new(buffer_size)
        
        if level.nil?
            result = FFI::Zlib.compress(compressed_buffer, compressed_buffer_size, @buffer, @data.length)
        else
            result = FFI::Zlib.compress2(compressed_buffer, compressed_buffer_size, @buffer, @data.length, level)
        end

        compressed_size = compressed_buffer_size.get_ulong(0)
        assert_equal result, FFI::Zlib::Z_OK
        
        uncompressed_buffer_size = FFI::Buffer.alloc_inout(:ulong).put_ulong(0, @data.length)
        uncompressed_buffer = FFI::MemoryPointer.new(@data.length)
        result = FFI::Zlib.uncompress(uncompressed_buffer, uncompressed_buffer_size, compressed_buffer, compressed_size)

        uncompressed_size = uncompressed_buffer_size.get_ulong(0)
        uncompressed = uncompressed_buffer.get_string(0)
        assert_equal result, FFI::Zlib::Z_OK
        assert_equal uncompressed_size, @data.length
        assert_equal uncompressed, @data
        
        return compressed_size
    end

end