# frozen_string_literal: true
require 'eventmachine'
require 'websocket-eventmachine-server'
require_relative 'opqr/observer'
require_relative 'opqr/api'
require_relative 'opqr/wsserver'
require_relative 'opqr/struct'
require_relative 'opqr/qqobj'
require_relative 'opqr/bot'
require_relative 'opqr/plugin'
require_relative "opqr/version"
module Opqr
  class Error < StandardError; end
  # Your code goes here...

end
