module Rasteira
  module EmbedWorker
    class Manager
      attr_reader :job_pool

      def initialize
        @job_pool = Array.new
        @mutex = Mutex.new
      end
      
      def self.run
        this = new
        this.run
        this
      end

      # TODO to be specifiable
      MIN_THREAD_SIZE = 5

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

      def enqueue_job!(worker_name, worker_file_path, *args)
        @mutex.synchronize do
          @job_pool << ::Rasteira::Core::Job.new(worker_name, worker_file_path, *args)
        end
      end
      
      def shutdown_workers!
        @thread_pool.each(&:kill)
        @thread_manager.kill
      end
      
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
