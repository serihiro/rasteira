# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'securerandom'

RSpec.describe Rasteira::Core::Job do
  before :all do
    @hello_worker_file = Tempfile.new(%w(worker .rb))

    class_string = <<~'EOS'
      class HelloWorker
        def perform(name1, name2)
          "Hello, #{name1} and #{name2}"
        end
      end
    EOS

    @hello_worker_file.print(class_string)
    @hello_worker_file.open
  end

  after :all do
    @hello_worker_file.delete
  end

  describe '.new' do
    subject { Rasteira::Core::Job.new(worker_name, worker_file_path: worker_file_path, args: args) }

    context 'with existing worker_file_path' do
      let(:worker_name) { 'HelloWorker' }
      let(:worker_file_path) { @hello_worker_file.path }
      let(:args) { %w(tarou jirou) }

      it 'create instance' do
        expect(subject.class).to eq Rasteira::Core::Job
      end
    end

    context 'with not existing worker_file_path' do
      let(:worker_name) { 'HelloWorker' }
      let(:worker_file_path) { SecureRandom.urlsafe_base64(64) }
      let(:args) { %w(tarou jirou) }

      it 'raises ArgumentError' do
        expect { subject.class }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#start!' do
    subject { Rasteira::Core::Job.new(worker_name, worker_file_path: worker_file_path, args: args).start! }
    let(:worker_name) { 'HelloWorker' }
    let(:worker_file_path) { @hello_worker_file.path }
    let(:args) { %w(tarou jirou) }

    it 'does not raise_error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#worker' do
    subject { Rasteira::Core::Job.new(worker_name, worker_file_path: worker_file_path, args: args).worker }
    let(:worker_name) { 'HelloWorker' }
    let(:worker_file_path) { @hello_worker_file.path }
    let(:args) { %w(tarou jirou) }

    it 'returns HelloWorker object' do
      expect(subject.class).to eq HelloWorker
    end
  end
end
