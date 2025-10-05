# frozen_string_literal: true

threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
threads threads_count, threads_count

workers ENV.fetch('WEB_CONCURRENCY', 4)
preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

port ENV.fetch('PORT', 3000)
plugin :tmp_restart
plugin :solid_queue if ENV['SOLID_QUEUE_IN_PUMA']
pidfile ENV['PIDFILE'] if ENV['PIDFILE']
