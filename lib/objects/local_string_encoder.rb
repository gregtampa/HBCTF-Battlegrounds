require 'getoptlong'
require_relative '../helpers/constants'
require 'json'
require 'base64'

# Inherited by local string encoders
# stdout used to return value
# use Print.local to print status messages (formatted to stdout)

# A nice side-effect is that each of these modules is also an executable script

class StringEncoder
  require_relative '../helpers/print.rb'

  attr_accessor :module_name
  attr_accessor :strings_to_encode
  attr_accessor :has_base64_inputs
  attr_accessor :outputs

  # override this
  def initialize
    # default values
    self.strings_to_encode = []
    self.module_name = 'Null encoder'
    self.has_base64_inputs = false
    self.outputs = []
  end

  # override this for per-item encoding
  def encode (str)
    str
  end

  # override this for array processing / aggregation
  def encode_all
    self.strings_to_encode.each do |value|
      self.outputs << encode(value)
    end
  end

  def read_arguments
    # Get command line arguments
    opts = get_options

    # process option arguments
    opts.each do |opt, arg|
      # Check if base64 decoding is required and set instance variable
      if opt == '--b64'
        self.has_base64_inputs = true
      end
      # Decode if required
      argument = self.has_base64_inputs ? Base64.strict_decode64(arg) : arg
      process_options(opt, argument)
    end
  end

  def get_options
    GetoptLong.new(*get_options_array)
  end

  # Override this when using read_fact's in your module.
  # Make sure you include the defaults by merging the 2D arrays using: super + [[a,b],[c,d]...]
  def get_options_array
    [['--help', '-h', GetoptLong::NO_ARGUMENT],
     ['--b64', GetoptLong::OPTIONAL_ARGUMENT],
     ['--strings_to_encode', '-s', GetoptLong::OPTIONAL_ARGUMENT]]
  end

  # Override this when using read_fact's in your module. Always call super first.
  def process_options(opt, arg)
    unless option_is_valid(opt)
      Print.err "Argument not valid: #{arg}"
      usage
      exit
    end

    case opt
      when '--help'
        usage
      when '--strings_to_encode'
        self.strings_to_encode << arg;
      when '--b64'
        # do nothing
    end
  end

  def usage
    Print.err "Usage:
   #{$0} [--options]

   OPTIONS:"
    valid_options = get_options_array
    valid_options.each { |option_array|
       option = option_array[0...-1].join(' ')
       Print.err((' '*5) + option)
     }
    exit
  end

  def run
    Print.local module_name

    read_arguments

    Print.local_verbose "Encoding '#{encoding_print_string}'"
    encode_all
    Print.local_verbose "Encoded: #{self.outputs.to_s}"
    puts has_base64_inputs ? base64_encode_outputs : self.outputs
  end

  def base64_encode_outputs
    self.outputs.map { |o| Base64.strict_encode64 o }
  end

  def encoding_print_string
    self.strings_to_encode.to_s
  end

  def option_is_valid(opt_to_check)
    option_validity = false
    valid_options = get_options_array

    valid_options.each{ |valid_opt_array|
      valid_opt_array.each_with_index  { |valid_opt|
        if valid_opt == opt_to_check
          option_validity = true
        end
      }
    }

    option_validity
  end
end
