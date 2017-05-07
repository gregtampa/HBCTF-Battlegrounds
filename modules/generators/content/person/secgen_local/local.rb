#!/usr/bin/ruby
require 'json'
require_relative '../../../../../lib/objects/local_string_encoder.rb'

class PersonHashBuilder < StringEncoder
  attr_accessor :name
  attr_accessor :address
  attr_accessor :phone_number
  attr_accessor :email_address
  attr_accessor :username

  def initialize
    super
    self.module_name = 'Person Hash Builder'
    self.name = ''
    self.address = ''
    self.phone_number = ''
    self.email_address = ''
    self.username = ''
  end

  def encode_all
    person_hash = {}
    person_hash['name'] = self.name
    person_hash['address'] = self.address
    person_hash['phone_number'] = self.phone_number
    person_hash['email_address'] = self.email_address
    person_hash['username'] = self.username

    self.outputs << person_hash.to_json
  end

  def get_options_array
    super + [['--name', GetoptLong::REQUIRED_ARGUMENT],
             ['--address', GetoptLong::REQUIRED_ARGUMENT],
             ['--phone_number', GetoptLong::REQUIRED_ARGUMENT],
             ['--email_address', GetoptLong::REQUIRED_ARGUMENT],
             ['--username', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
      when '--name'
        self.name << arg;
      when '--address'
        self.address << arg;
      when '--phone_number'
        self.phone_number << arg;
      when '--email_address'
        self.email_address << arg;
      when '--username'
        self.username << arg;
    end
  end

  def encoding_print_string
    'name: ' + self.name.to_s + ',
    address: ' + self.address.to_s  + ',
    phone_number: ' + self.phone_number.to_s + ',
    email_address: ' + self.email_address.to_s + ',
    username: ' + self.username.to_s
  end
end

PersonHashBuilder.new.run
