# frozen_string_literal: true

require 'ostruct'
require 'pathname'
require 'bigdecimal'
require 'bigdecimal/util'
require 'csv'

Config = OpenStruct.new
Config.root = Pathname.new(File.expand_path(__dir__))

[%w[../lib/billing_machine ** *.rb]].each do |folder|
  Dir.glob(Config.root.join(*folder)).each { |file| require file }
end
