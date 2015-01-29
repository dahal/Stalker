#!/usr/bin/env ruby
require 'rubygems'
require 'chatterbot/dsl'
require 'slack-notifier'
require 'dotenv'
Dotenv.load

consumer_secret ENV['CONSUMER_SECRET']
secret ENV['SECRET']
token ENV['TOKEN']
consumer_key ENV['CONSUMER_KEY']

puts "Stalking Twitter now..."

def search_for(keywords)
  streaming(endpoint: :filter, locations:"-122.75,36.8,-121.75,37.8") do
    user do |tweet|
      username = tweet.user.screen_name
      tweety = tweet.text
      puts "Not Tracking: #{username.colorize(:blue)} :- #{tweety.colorize(:yellow)} + #{tweet.uri.to_s}"

      keywords.each do |word|
        if tweet.text.downcase.split.include? word
          puts "Now Tracking: #{username.colorize(:red)} :- #{tweety.colorize(:green)}"
          notifier = Slack::Notifier.new ENV['WEBHOOK_URL']
          notifier.ping "#{tweet.uri.to_s}"
        end
      end
    end
  end

  search_for(keywords)
end

# keywords = %w(
#   usps #usps @usps @uspshelp
#   ups #ups @ups @upshelp
#   fedex #fedex @fedex @fedexhelp
#   uspssucks #uspssucks
#   fedexsucks #fedexsucks
#   upssucks #upssucks
#   emssucks #emssucks
#   lostpackages #lostpackages
#   lostpackage #lostpackage
#   missingpackage #missingpackage
#   missingpackages #missingpackages
#   doorman #doorman @doorman_it
# )

keywords = %w(
  @uspshelp #uspshelp
  @upshelp #upshelp
  @fedexhelp #fedexhelp
  uspssucks #uspssucks
  fedexsucks #fedexsucks
  upssucks #upssucks
  emssucks #emssucks
  lostpackages #lostpackages
  lostpackage #lostpackage
  missingpackage #missingpackage
  missingpackages #missingpackages
  misseddelivery #misseddelivery
  lostdelivery #lostdelivery
  #delivery
  doorman #doorman
  @doorman_it
)

search_for(keywords)
