#!/usr/bin/env ruby
require 'open3'
if ENV['RUN_CREATE'] == "true"
  failed = true
  Dir.chdir('/home/app/myapp'){
    loop do
      stdout, stderr, status = Open3.capture3("setuser app bundle exec rake db:create")
      puts stdout
      puts stderr
      puts status
      if stderr.empty? && status.exitstatus == 0
        failed = false
        break
      elsif stderr.include?('already exists')
        failed = false
        break
      elsif !stderr.include?('Can\'t connect to MySQL server on')
        break
      end

      sleep(10)
    end
  }
  abort("Creating Database FAILED...") if failed
end
