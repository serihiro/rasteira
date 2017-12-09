# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rasteira::EmbedWorker::Manager do
  describe '#run' do
    let(:manager) { Rasteira::EmbedWorker::Manager.new }

    it 'charges thread pool' do
      expect do
        manager.run
      end.to change { manager.instance_variable_get(:@thread_pool).size }.from(0).to(5)
    end

    it 'starts thread_manager thread' do
      manager.run
      thread_manager = manager.instance_variable_get(:@thread_manager)
      expect(thread_manager.alive?).to eq true
    end
  end

  describe '.run' do
    subject { Rasteira::EmbedWorker::Manager.run }

    it 'returns manager instance' do
      expect(subject.class).to eq Rasteira::EmbedWorker::Manager
    end

    it 'charges thread pool' do
      expect(subject.instance_variable_get(:@thread_pool).size).to eq 5
    end

    it 'starts thread_manager thread' do
      thread_manager = subject.instance_variable_get(:@thread_manager)
      expect(thread_manager.alive?).to eq true
    end
  end

  describe '#enqueue_job!' do
    before :each do
      # mock
      module Rasteira
        module Core
          class Job
            def initialize(_worker_name, _options = {}); end
          end
        end
      end
    end
    let(:manager) { Rasteira::EmbedWorker::Manager.new }

    context 'with worker_path' do
      subject { manager.enqueue_job!('worker_name', worker_path: 'worker_path') }

      it 'increase @job_pool count' do
        expect { subject }.to change { manager.job_pool.size }.from(0).to(1)
      end
    end

    context 'without worker_path' do
      subject { manager.enqueue_job!('worker_name') }

      it 'increase @job_pool count' do
        expect { subject }.to change { manager.job_pool.size }.from(0).to(1)
      end
    end
  end

  describe '#shutdown_workers!' do
    let(:manager) { Rasteira::EmbedWorker::Manager.run }

    it 'stop all threads of @thread_pool and @thread_manager' do
      manager.shutdown_workers!
      sleep(0.1)
      expect(manager.instance_variable_get(:@thread_pool).all? { |t| t.status == false }).to eq true
      expect(manager.instance_variable_get(:@thread_manager).status).to eq false
    end
  end
end
