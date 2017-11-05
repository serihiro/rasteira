# To test with bin/console, execute like this:
#
# 2.4.0 :001 > m = Rasteira::EmbedWorker::Manager.run
# 2.4.0 :002 > m.enqueue_job!('HelloWorker', 'example/hello_worker.rb', 'serihiro')
#
class HelloWorker
  def perform(name)
    puts "Hello, #{name}"
  end
end
