#!/usr/bin/env ruby
require "rubygems"
require "faker"

require "csv"

line_count = ARGV.empty? ? 15 : ARGV.first.to_i

CSV( STDOUT ) do |csv|
  (1..line_count).each do |i|
    row = [
      (i + 1000000).to_s,
      Faker::Internet.user_name + '@ctr.uberether.com'
    ]
    csv << row
  end
  (1..20).each do |i|
    row = [
      (i + 2000000).to_s,
      Faker::Internet.user_name + '@uberether.com'
    ]
    csv << row
  end
end
