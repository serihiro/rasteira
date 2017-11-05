module Rasteira
  module Core
    class Job
      attr_reader :worker_name, :worker_file_path, :args, :status
      
      STATUSES = {
        ready: 0,
        in_process: 1,
        finished: 2,
        failed: 3
      }.freeze
    
      def initialize(worker_name, worker_file_path, *args)
        @worker_file_path = File.expand_path(worker_file_path, Dir.pwd)
        unless File.exists?(@worker_file_path)
          raise ArgumentError.new("#{@worker_file_path} could not be found")
        end
      
        require(@worker_file_path)
        @worker_name = worker_name
        @args = args
        @status = STATUSES[:ready]
      end
    
      def start!
        @status = STATUSES[:in_process]
        begin
          worker.perform(*@args)
          @status = STATUSES[:finished]
        rescue => e
          @status = STATUSES[:failed]
          raise e
        end
      end
    
      def worker
        @worker ||= Object.const_get("::#{@worker_name}").new
      end
    end
  end
end
