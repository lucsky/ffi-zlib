require "test/unit"
require "ffi/zlib"
require "test/helper.rb"

class TestAdler32 < Test::Unit::TestCase
    include Setup

    EXPECTED_ADLER32_1    = 3874980441
    EXPECTED_ADLER32_2    = 1707704336
    EXPECTED_ADLER32_FULL = 869204599
    
    def adler32(data)
        @buffer.put_string(0, data)
        checksum = FFI::Zlib.adler32(0, nil, 0)
        FFI::Zlib.adler32(checksum, @buffer, data.length)
    end
    
    def test_adler32
        checksum = self.adler32(@data)
        assert_equal checksum, EXPECTED_ADLER32_FULL
    end

    def test_running_adler32
        checksum = FFI::Zlib.adler32(0, nil, 0)
        @data.each_line do |line|
            @buffer.put_string(0, line)
            checksum = FFI::Zlib.adler32(checksum, @buffer, line.length)
        end

        assert_equal checksum, EXPECTED_ADLER32_FULL
    end

    def test_adler32_combine
        middle, _ = @data.length.divmod(2)
        piece1 = @data[0...middle]
        piece2 = @data[middle..-1]

        checksum1 = self.adler32(piece1)
        checksum2 = self.adler32(piece2)
        checksum = FFI::Zlib.adler32_combine(checksum1, checksum2, piece2.length)

        assert_equal checksum1, EXPECTED_ADLER32_1
        assert_equal checksum2, EXPECTED_ADLER32_2
        assert_equal checksum,  EXPECTED_ADLER32_FULL
    end
    
    
end

class TestCRC32 < Test::Unit::TestCase
    include Setup

    EXPECTED_CRC32_1      = 4007132158
    EXPECTED_CRC32_2      = 1117097248
    EXPECTED_CRC32_FULL   = 703194008

    def crc32(data)
        @buffer.put_string(0, data)
        checksum = FFI::Zlib.crc32(0, nil, 0)
        checksum = FFI::Zlib.crc32(checksum, @buffer, data.length)
    end
    
    def test_crc32
        checksum = self.crc32(@data)
        assert_equal checksum, EXPECTED_CRC32_FULL
    end

    def test_running_crc32
        checksum = FFI::Zlib.crc32(0, nil, 0)
        @data.each_line do |line|
            @buffer.put_string(0, line)
            checksum = FFI::Zlib.crc32(checksum, @buffer, line.length)
        end

        assert_equal checksum, EXPECTED_CRC32_FULL
    end

    def test_crc32_combine
        middle, _ = @data.length.divmod(2)
        piece1 = @data[0...middle]
        piece2 = @data[middle..-1]

        checksum1 = self.crc32(piece1)
        checksum2 = self.crc32(piece2)
        checksum = FFI::Zlib.crc32_combine(checksum1, checksum2, piece2.length)

        assert_equal checksum1, EXPECTED_CRC32_1
        assert_equal checksum2, EXPECTED_CRC32_2
        assert_equal checksum,  EXPECTED_CRC32_FULL
    end

end