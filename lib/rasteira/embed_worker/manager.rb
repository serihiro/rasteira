module Rasteira
  module EmbedWorker
    class Manager
      attr_reader :job_pool

      def initialize
        @job_pool = Array.new
        @thread_pool = Array.new
        @mutex = Mutex.new
      end
      
      # Create manager instance and run
      # @return [Rasteira::EmbedWorker::Manager] an instance of a running manager
      def self.run
        this = new
        this.run
        this
      end

      # TODO to be specifiable
      MIN_THREAD_SIZE = 5

      # Create thread pool and start all threads
      # @return [nil]
      def run
        @thread_pool = MIN_THREAD_SIZE.times.map do
          Thread.start { worker_thread_process }
        end
        
        @thread_manager = Thread.start do
          loop do
            @mutex.synchronize do
              @thread_pool.reject! { |thread| !thread.alive? }
              
              (@thread_pool.size...MIN_THREAD_SIZE).each do
                @thread_pool << Thread.start { worker_thread_process }
              end
            end

            sleep(1)
          end
        end
      end

      # Enqueue new job
      # @param [String] worker_name the name of worker class
      # @param [Hash] options
      # @option options [String] :worker_file_path the file path of worker script
      # @option options [String] :current_directory the directory where you want to handle as a current directory
      # @option options [Object] :args the arguments for the perform method in the worker class
      # @return [Rasteira::Core::Job] job created job
      def enqueue_job!(worker_name, options = {})
        @mutex.synchronize do
          @job_pool << ::Rasteira::Core::Job.new(worker_name, options)
        end
      end
      
      # Kill all worker threads
      # @return nil
      def shutdown_workers!
        @thread_pool.each(&:kill)
        @thread_manager.kill
      end
      
      # Return current worker threads id and status hashes
      # @return [Array<Hash>]
      def worker_statuses
        @thread_pool.map do |thread|
          { id: thread.object_id, status: thread.status }
        end
      end
      
      private

      def worker_thread_process
        loop do
          begin
            job = nil
            @mutex.synchronize do
              job = @job_pool.pop
            end
            if !job.nil?
              job.start!
            else
              sleep(3)
            end
          rescue => e
            # TODO logging
            puts e.inspect
          end
        end
      end
    end
  end
end
