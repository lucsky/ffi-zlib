require "test/unit"
require "ffi/zlib"
require "test/helper.rb"

class TestDeflate < Test::Unit::TestCase

    def setup
        @data = File.read(File.join("test", "fixtures", "pale_blue_dot.txt"))
        @buffer = FFI::MemoryPointer.new(@data.length)
        @buffer.put_string(0, @data)
    end
    
    def test_deflate
        s1 = do_test_deflate(FFI::Zlib::Z_NO_COMPRESSION)
        s2 = do_test_deflate(FFI::Zlib::Z_BEST_SPEED)
        s3 = do_test_deflate(FFI::Zlib::Z_DEFAULT_COMPRESSION)
        s4 = do_test_deflate(FFI::Zlib::Z_BEST_COMPRESSION)

        assert s1 > s2
        assert s2 > s3
        assert s3 >= s4
    end
    
    def do_test_deflate(level)
        avail_out = @data.length + 64
        compressed_buffer = FFI::MemoryPointer.new(avail_out)

        zstream = FFI::Zlib::Z_stream.new
        zstream[:next_in] = @buffer
        zstream[:avail_in] = @data.length
        zstream[:next_out] = compressed_buffer
        zstream[:avail_out] = avail_out

        result = FFI::Zlib.deflateInit(zstream, level)
        assert_equal result, FFI::Zlib::Z_OK

        result = FFI::Zlib.deflate(zstream, FFI::Zlib::Z_FINISH)
        assert_equal result, FFI::Zlib::Z_STREAM_END

        result = FFI::Zlib.deflateEnd(zstream)
        assert_equal result, FFI::Zlib::Z_OK
        
        compressed_size = zstream[:total_out]
        assert compressed_size > 0
        assert compressed_size <= @data.length if level != FFI::Zlib::Z_NO_COMPRESSION

        decompressed_buffer = FFI::MemoryPointer.new(@data.length)
        zstream = FFI::Zlib::Z_stream.new
        zstream[:next_in] = compressed_buffer
        zstream[:avail_in] = compressed_size
        zstream[:next_out] = decompressed_buffer
        zstream[:avail_out] = @data.length

        result = FFI::Zlib.inflateInit(zstream)
        assert_equal result, FFI::Zlib::Z_OK

        result = FFI::Zlib.inflate(zstream, FFI::Zlib::Z_FINISH)
        assert_equal result, FFI::Zlib::Z_STREAM_END

        result = FFI::Zlib.inflateEnd(zstream)
        assert_equal result, FFI::Zlib::Z_OK

        decompressed_size = zstream[:total_out]
        decompressed_data = decompressed_buffer.get_string(0, decompressed_size)
        assert_equal decompressed_size, @data.length
        assert_equal decompressed_data, @data

        return compressed_size
    end

end
