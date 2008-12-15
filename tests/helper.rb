module Setup
    def setup
        @data = File.read(File.join("tests", "support", "pale_blue_dot.txt"))
        @buffer = FFI::Buffer.alloc_in(4096)
    end
end
