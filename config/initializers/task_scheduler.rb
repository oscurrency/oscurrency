# Only one instance of scheduler at the time. 
# Lockfile feature only works on OSes that support the flock (man 2 flock) call.
# scheduler = Rufus::Scheduler.new(:lockfile => ".task-scheduler.lock")
# 
# At the end of month on 11:00 pm.
# scheduler.cron '0 23 L * *' do
  # begin
    # Account.calculate_demmurage()
  # rescue => e
    # $stderr.puts '-' * 80
    # $stderr.puts e.message
    # $stderr.puts e.stacktrace
    # $stderr.puts '-' * 80
  # end
# end
