require 'clockwork'
include Clockwork
require 'active_support/time'
require './config/boot'

module Clockwork
  handler do |job|
    case job
    # when 'frequent.job'
    #   `rails runner -e development 'require "./lib/tasks/batch"; Tasks::Batch.frequent'`
# バッチファイルのアクション名と、フリーク園と部分を対応させるY
# binding.pry
    when 'midnight.job'
      puts "xxxxx1"
      begin
        `rails runner -e development 'require "C:/Users/s.shimaya/develpment/kanekaesou_app/lib/tasks/batch"; Tasks::Batch.execute'`
      ensure
        puts "xxxxx2"
      end

    end
  end

  # every(1.minute, 'frequent.job')
  every(1.day, 'midnight.job', :at => '09:00')
  # every(1.seconds, 'midnight.job')
end
