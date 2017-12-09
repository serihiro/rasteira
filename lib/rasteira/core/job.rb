# frozen_string_literal: true

module Rasteira
  module Core
    # Job class that is executed by rasteira.
    class Job
      attr_reader :worker_class, :worker_file_path, :args, :status

      STATUSES = {
        ready: 0,
        in_process: 1,
        finished: 2,
        failed: 3
      }.freeze

      # The constructor of Rasteira::Core::Job
      # @param [String, Class] worker_class The name or class of worker class or
      # @param [Hash] options
      # @option options [String] :worker_file_path The file path of worker_class.
      #   If worker_file_path is set, Rasteira tries to load worker_class from worker_file_path
      # @option options [String] :current_directory The root path of worker_file_path.
      #   If current_directory and worker_file_path are set, Rasteira searches worker_file_path
      #   with current_directory as current directory.
      def initialize(worker_class, options = {})
        unless options[:worker_file_path].nil?
          @worker_file_path = File.expand_path(options[:worker_file_path], options[:current_directory] || Dir.pwd)
          unless File.exist?(@worker_file_path)
            raise ArgumentError, "#{@worker_file_path} could not be found"
          end

          require(@worker_file_path)
        end

        @worker_class = worker_class
        @args = options[:args]
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
        @worker ||= if @worker_class.is_a?(String)
                      Object.const_get("::#{@worker_class}").new
                    else
                      @worker_class.new
                    end
      end
    end
  end
end
