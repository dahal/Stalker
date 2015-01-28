#!/usr/bin/env ruby
require 'rubygems'
require 'chatterbot/dsl'
require 'slack-notifier'
require 'dotenv'
Dotenv.load

slack_webhook_url = ENV['WEBHOOK_URL']
consumer_secret ENV['CONSUMER_SECRET']
secret ENV['SECRET']
token ENV['TOKEN']
consumer_key ENV['CONSUMER_KEY']

puts "Stocking Twitter now..."

keywords = ENV['KEYWORDS']

streaming(endpoint: :filter, locations:"-122.75,36.8,-121.75,37.8") do
  user do |tweet|
    username = tweet.user.screen_name
    tweety = tweet.text
    puts "Not Tracking: #{username.colorize(:blue)} :- #{tweety.colorize(:yellow)}"

    if tweet.text.split.join(" ") =~ keywords
      puts "Now Tracking: #{username.colorize(:red)} :- #{tweety.colorize(:green)}"
      notifier = Slack::Notifier.new slack_webhook_url
      notifier.ping "#{tweet.uri.to_s}"
    end
  end
end
