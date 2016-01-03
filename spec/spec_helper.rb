# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
# $LOAD_PATH.unshift(File.dirname(__FILE__))
# require 'rspec'
# require 'calculator'

# RSpec.configure do |config|
#   config.order = 'random'
# end

require 'rspec'

require_relative '../lib/calculator'

RSpec.configure do |config|
  config.color = true
  config.order = 'random'
end