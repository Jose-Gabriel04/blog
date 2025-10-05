# db/seeds.rb
require 'benchmark'
require 'securerandom'
require 'json'
require 'fileutils'

class CurlSeeder
  BASE_URL = 'http://localhost:3000'
  TOTAL_POSTS = 200_000
  TOTAL_USERS = 100
  UNIQUE_IPS = 50
  RATING_PERCENTAGE = 0.75
  PARALLEL_PROCESSES = 30
  
  def initialize
    @start_time = Time.now
    @ips = generate_ips
    @users = generate_users
    @posts_file = 'seed_requests.txt'
    @ratings_file = 'ratings_requests.txt'
  end

  def seed!
    print_start_information
    
    total_time = Benchmark.measure do
      cleanup_temp_files

      posts_time = Benchmark.measure do
        seed_posts
      end

      ratings_time = Benchmark.measure do
        seed_ratings
      end
    end
    
    print_final_statistics(total_time.real)
    cleanup_temp_files
  end

  private

  def generate_ips
    UNIQUE_IPS.times.map { "192.168.#{rand(1..10)}.#{rand(1..254)}" }
  end

  def generate_users
    TOTAL_USERS.times.map { |i| "user_#{i + 1}_#{SecureRandom.hex(4)}" }
  end

  def seed_posts
    puts "\n" + "="*60
    puts "📝 PHASE 1: Creating #{TOTAL_POSTS.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse} posts"
    puts "="*60

    generation_start = Time.now
    puts "\n⏳ Generating curl commands file..."
    
    File.open(@posts_file, 'w') do |file|
      TOTAL_POSTS.times do |i|
        username = @users.sample
        ip = @ips.sample
        
        post_data = {
          "title": "Post #{i + 1} - #{generate_title}",
          "body": generate_body,
          "user_login": username,
          "ip": ip
        }

        json_string = post_data.to_json
        curl_cmd = "curl --silent --output /dev/null -X POST #{BASE_URL}/posts -H 'Content-Type: application/json' -d '#{json_string}'"
        file.puts curl_cmd
      end
    end
    
    file_size_mb = File.size(@posts_file) / (1024.0 * 1024.0)
    puts "✅ Generated #{@posts_file} (#{file_size_mb.round(2)} MB) in #{(Time.now - generation_start).round(2)}s"

    execution_start = Time.now
    puts "\n⚡ Executing requests with xargs -P #{PARALLEL_PROCESSES}..."
    puts "⏳ This may take a few minutes..."

    system("cat #{@posts_file} | xargs -n 1 -P #{PARALLEL_PROCESSES} -d '\\n' sh -c")

    execution_time = Time.now - execution_start
    requests_per_second = (TOTAL_POSTS / execution_time).round(2)
    
    puts "\n✅ Posts created in #{(execution_time / 60).round(2)} minutes"
    puts "📊 Performance: #{requests_per_second} requests/second"
  end

  def seed_ratings
    @posts_ids = Post.pluck(:id)
    @posts_to_rate = (@posts_ids.size * RATING_PERCENTAGE).to_i
    @user_ids = User.pluck(:id)
    
    puts "\n" + "="*60
    puts "⭐ PHASE 3: Creating ratings for #{@posts_to_rate} posts (#{(RATING_PERCENTAGE * 100).to_i}%)"
    puts "="*60
    
    generation_start = Time.now
    puts "\n⏳ Generating rating commands..."

    File.open(@ratings_file, 'w') do |file|
      @posts_ids.sample(@posts_to_rate).each do |post_id|
        user_id = @user_ids.sample

        rating_data = {
          "post_id": post_id.to_s,
          "user_id": user_id.to_s,
          "value": rand(1..5).to_s
        }

        json_string = rating_data.to_json
        curl_cmd = "curl --silent --output /dev/null -X POST #{BASE_URL}/ratings -H 'Content-Type: application/json' -d '#{json_string}'"
        
        file.puts curl_cmd
      end
    end

    execution_start = Time.now
    puts "\n⚡ Executing rating requests with xargs -P #{PARALLEL_PROCESSES}..."

    system("cat #{@ratings_file} | xargs -n 1 -P #{PARALLEL_PROCESSES} -d '\\n' sh -c")
    
    execution_time = Time.now - execution_start
    ratings_per_second = (Rating.count / execution_time).round(2)
    
    puts "\n✅ Ratings created in #{(execution_time / 60).round(2)} minutes"
    puts "📊 Performance: #{ratings_per_second} ratings/second"
  end

  def generate_title
    adjectives = %w[Amazing Great Fantastic Awesome Incredible Wonderful Brilliant Excellent Superb Outstanding]
    nouns = %w[Post Article Story Update News Content Blog Entry Note Message]
    "#{adjectives.sample} #{nouns.sample}"
  end

  def generate_body
    pronouns = %w[I you he she it we they me us them]

    adjectives = %w[happy sad big small beautiful ugly fast slow strong weak]

    verbs = %w[run eat sleep write read speak listen go make play]
    "#{adjectives.sample} #{pronouns.sample} #{verbs.sample} #{adjectives.sample} #{pronouns.sample} #{verbs.sample}"
  end

  def cleanup_temp_files
    [@posts_file, @ratings_file].each do |file|
      File.delete(file) if File.exist?(file)
    end
  end

  def print_final_statistics(total_seconds)
    puts "\n" + "="*60
    puts "🎉 SEED COMPLETED SUCCESSFULLY!"
    puts "="*60
    puts "📊 Final Statistics:"
    puts "  • Total time: #{(total_seconds / 60).round(2)} minutes"
    puts "  • Posts created: #{@posts_ids&.size || 0}"
    puts "  • Users created: #{@user_ids&.size || 0}"
    puts "  • Average speed: #{(TOTAL_POSTS / total_seconds).round(2)} ops/second"
    puts "="*60
    
    if total_seconds > 600
      puts "\n💡 Performance Tips:"
      puts "  2. Check your Rails server configuration (workers/threads)"
      puts "  3. Optimize database connection pool size"
      puts "  4. Consider using production mode: RAILS_ENV=production"
      puts "  5. Install 'pv' for progress monitoring: sudo apt-get install pv"
    end
    puts "="*60

  end

  def print_start_information
    puts "\n" + "="*60
    puts "🚀 STARTING SEED GENERATION WITH CURL"
    puts "="*60
    puts 'Consider uncommenting log lines in development.rb'
    puts "Configuration:"
    puts "  • Total posts: #{TOTAL_POSTS.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
    puts "  • Unique users: #{TOTAL_USERS}"
    puts "  • Unique IPs: #{UNIQUE_IPS}"
    puts "  • Parallel processes: #{PARALLEL_PROCESSES}"
    puts "="*60
  end
end

seeder = CurlSeeder.new
seeder.seed!
