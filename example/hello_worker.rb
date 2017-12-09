# frozen_string_literal: true

# To test with bin/console, execute like this:
#
# 2.4.0 :001 > m = Rasteira::EmbedWorker::Manager.run
# 2.4.0 :002 > m.enqueue_job!('HelloWorker', worker_file_path: 'example/hello_worker.rb', args: ['serihiro', 'hogetarou'])
#
# OR
#
# 2.4.0 :001 > m = Rasteira::EmbedWorker::Manager.run
# 2.4.0 :002 > require './example/hello_worker.rb'
# 2.4.0 :003 > m.enqueue_job!('HelloWorker', args: ['serihiro', 'hogetarou'])
#
class HelloWorker
  def perform(name1, name2)
    puts "Hello, #{name1}, #{name2}"
  end
end
