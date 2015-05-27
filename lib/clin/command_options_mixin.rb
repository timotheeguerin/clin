require 'clin'
require 'clin/option'

# Template class for reusable options and commands
# It provide the method to add options to a command
class Clin::CommandOptionsMixin
  class_attribute :options

  class_attribute :general_options
  self.options = []
  self.general_options = []


  # Add an option
  # @param args list of arguments.
  #   * First argument must be the name if no block is given.
  #     It will set automatically read the value into the hash with  +name+ as key
  #   * The remaining arguments are OptionsParser#on arguments
  # ```
  #   option :require, '-r', '--require [LIBRARY]', 'Require the library'
  #   option '-h', '--helper', 'Show the help' do
  #     puts opts
  #     exit
  #   end
  # ```
  def self.opt_option(*args, &block)
    add_option Clin::Option.new(*args, &block)
  end

  # Add an option.
  # Helper method that just create a new Clin::Option with the argument then call add_option
  # ```
  #   option :show, 'Show some message'
  #   # => -s --show              SHOW Show some message
  #   option :require, 'Require a library', short: false, optional: true, argument: 'LIBRARY'
  #   # => --require [LIBRARY]    Require a library
  #   option :help, 'Show the help', argument: false do
  #     puts opts
  #     exit
  #   end
  #   # => -h --help              Show the help
  # ```
  def self.option(name, description, **config, &block)
    add_option Clin::Option.new(name, description, **config, &block)
  end

  # For an option that does not have an argument
  # Same as .option except it will default argument to false
  # ```
  #   option :verbose, 'Use verbose' #=> -v --verbose will be added to the option of this command
  # ```
  def self.flag_option(name, description, **config, &block)
    add_option Clin::Option.new(name, description, **config.merge(argument: false), &block)
  end

  def self.add_option(option)
    # Need to use += instead of << otherwise the parent class will also be changed
    self.options += [option]
  end

  # Add a general option
  # @param option_cls [Class<GeneralOption>] Class inherited from GeneralOption
  # @param config [Hash] General option config. Check the general option config.
  def self.general_option(option_cls, config = {})
    self.general_options += [option_cls.new(config)]
  end

  # To be called inside OptionParser block
  # Extract the option in the command line using the OptionParser and map it to the out map.
  # @param opts [OptionParser]
  # @param out [Hash] Where the options shall be extracted
  def self.register_options(opts, out)
    options.each do |option|
      option.register(opts, out)
    end

    general_options.each do |option|
      option.class.register_options(opts, out)
    end
  end
end
