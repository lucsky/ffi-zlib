# =============================================================================

require "rubygems"
require "ffi"

# =============================================================================

module FFI::Zlib
    extend FFI::Library
    ffi_lib("z")

    # -------------------------------------------------------------------------

    attach_function :zlibVersion, [ ], :string

    # -------------------------------------------------------------------------

    ZLIB_VERSION            = zlibVersion()

    # Allowed flush values.

    Z_NO_FLUSH              = 0
    Z_PARTIAL_FLUSH         = 1
    Z_SYNC_FLUSH            = 2
    Z_FULL_FLUSH            = 3
    Z_FINISH                = 4
    Z_BLOCK                 = 5

    # Return codes for the compression/decompression functions. 
    # Negative values are errors, positive values are used for special but 
    # normal events.

    Z_OK                    = 0
    Z_STREAM_END            = 1
    Z_NEED_DICT             = 2
    Z_ERRNO                 = -1
    Z_STREAM_ERROR          = -2
    Z_DATA_ERROR            = -3
    Z_MEM_ERROR             = -4
    Z_BUF_ERROR             = -5
    Z_VERSION_ERROR         = -6
    
    # Compression levels.
    
    Z_NO_COMPRESSION        = 0
    Z_BEST_SPEED            = 1
    Z_BEST_COMPRESSION      = 9
    Z_DEFAULT_COMPRESSION   = -1
    
    # Compression strategies.
    
    Z_FILTERED              = 1
    Z_HUFFMAN_ONLY          = 2
    Z_RLE                   = 3
    Z_FIXED                 = 4
    Z_DEFAULT_STRATEGY      = 0

    # Possible values of the data_type field.

    Z_BINARY                = 0
    Z_TEXT                  = 1
    Z_UNKNOWN               = 2

    # The deflate compression method (the only one supported).

    Z_DEFLATED              = 8

    # -------------------------------------------------------------------------
    
    class Z_stream < FFI::Struct
        layout  :next_in,       :pointer,
                :avail_in,      :uint,
                :total_in,      :ulong,
                
                :next_out,      :pointer,
                :avail_out,     :uint,
                :total_out,     :ulong,
                
                :msg,           :string,
                :state,         :pointer,
                
                :alloc_func,    :pointer,
                :free_func,     :pointer,
                :opaque,        :pointer,
                
                :data_type,     :int,
                :adler,         :ulong,
                :reserved,      :ulong
    end

    # -------------------------------------------------------------------------

    class GZ_header < FFI::Struct
        layout  :text,          :int,
                :time,          :ulong,
                :xflags,        :int,
                :os,            :int,

                :extra,         :pointer,
                :extra_len,     :uint,
                :extra_max,     :uint,

                :name,          :string,
                :name_max,      :uint,
                :comment,       :string,
                :comm_max,      :uint,
                
                :hcrc,          :int,
                :done,          :int
    end

    # -------------------------------------------------------------------------
            
    def self.deflateInit(zstream, level)
        deflateInit_(zstream, level, ZLIB_VERSION, zstream.size)
    end

    def self.deflateInit2(zstream, level, method, window_bits, mem_level, strategy)
        deflateInit2_(zstream, level, method, window_bits, mem_level, strategy, ZLIB_VERSION, zstream.size)
    end

    attach_function :deflateInit_, [:pointer, :int, :string, :int], :int
    attach_function :deflateInit2_, [:pointer, :int, :int, :int, :int, :int, :string, :int], :int
    attach_function :deflate, [:pointer, :int], :int
    attach_function :deflateEnd, [:pointer], :int

    attach_function :deflateSetDictionary, [:pointer, :pointer, :uint], :int
    attach_function :deflateCopy, [:pointer, :pointer], :int
    attach_function :deflateReset, [:pointer], :int
    attach_function :deflateParams, [:pointer, :int, :int], :int
    attach_function :deflateTune, [:pointer, :int, :int, :int, :int], :int
    attach_function :deflateBound, [:pointer, :ulong], :ulong
    attach_function :deflatePrime, [:pointer, :int, :int], :int
    attach_function :deflateSetHeader, [:pointer, :pointer], :int

    # -------------------------------------------------------------------------

    def self.inflateInit(zstream)
        inflateInit_(zstream, ZLIB_VERSION, zstream.size)
    end

    def self.inflateInit2(zstream, window_bits)
        inflateInit2_(zstream, window_bits, ZLIB_VERSION, zstream.size)
    end

    attach_function :inflateInit_, [:pointer, :string, :int], :int
    attach_function :inflateInit2_, [:pointer, :int, :string, :int], :int
    attach_function :inflate, [:pointer, :int], :int
    attach_function :inflateEnd, [:pointer], :int
    
    attach_function :inflateSetDictionary, [:pointer, :pointer, :uint], :int
    attach_function :inflateSync, [:pointer], :int
    attach_function :inflateCopy, [:pointer, :pointer], :int
    attach_function :inflateReset, [:pointer], :int
    attach_function :inflatePrime, [:pointer, :int, :int], :int
    attach_function :inflateGetHeader, [:pointer, :pointer], :int

    callback :in_func, [:pointer, :pointer], :uint
    callback :out_func, [:pointer, :pointer, :uint], :int

    attach_function :inflateBackInit_, [:pointer, :int, :pointer], :int
    attach_function :inflateBack, [:pointer, :in_func, :pointer, :out_func, :pointer], :int
    attach_function :inflateBackEnd, [:pointer], :int

    # -------------------------------------------------------------------------

    attach_function :compress, [:pointer, :buffer_inout, :pointer, :ulong], :int
    attach_function :compress2, [:pointer, :pointer, :pointer, :ulong, :int], :int
    attach_function :compressBound, [:ulong], :ulong

    attach_function :uncompress, [:pointer, :buffer_inout, :pointer, :ulong], :int

    # -------------------------------------------------------------------------

    attach_function :gzopen, [:string, :string], :pointer
    attach_function :gzdopen, [:int, :string], :pointer
    attach_function :gzsetparams, [:pointer, :int, :int], :int
    attach_function :gzread, [:pointer, :pointer, :uint], :int
    attach_function :gzwrite, [:pointer, :pointer, :uint], :int
    attach_function :gzprintf, [:pointer, :string, :varargs], :int
    attach_function :gzputs, [:pointer, :string], :int
    attach_function :gzgets, [:pointer, :pointer, :int], :pointer
    attach_function :gzputc, [:pointer, :int], :int
    attach_function :gzgetc, [:pointer, :pointer], :int
    attach_function :gzungetc, [:int, :pointer], :int
    attach_function :gzflush, [:pointer, :int], :int
    attach_function :gzseek, [:pointer, :long, :int], :long
    attach_function :gzrewind, [:pointer], :int
    attach_function :gztell, [:pointer], :long
    attach_function :gzeof, [:pointer], :int
    attach_function :gzdirect, [:pointer], :int
    attach_function :gzclose, [:pointer], :int
    attach_function :gzerror, [:pointer, :buffer_out], :string
    attach_function :gzclearerr, [:pointer], :void

    # -------------------------------------------------------------------------

    attach_function :adler32, [:ulong, :pointer, :uint], :ulong
    attach_function :adler32_combine, [:ulong, :ulong, :long], :ulong
    attach_function :crc32, [:ulong, :pointer, :uint], :ulong
    attach_function :crc32_combine, [:ulong, :ulong, :long], :ulong

    # -------------------------------------------------------------------------
        
    attach_function :zlibCompileFlags, [ ], :ulong
    attach_function :zError, [:int], :string
    attach_function :inflateSyncPoint, [:pointer], :int
    attach_function :get_crc_table, [ ], :pointer

    # -------------------------------------------------------------------------
end

# =============================================================================
