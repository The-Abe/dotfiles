#!/usr/bin/env ruby
require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

puts "Loading pry version #{Pry::VERSION}"
Pry.start
exit # Explicit, so it closes irb
