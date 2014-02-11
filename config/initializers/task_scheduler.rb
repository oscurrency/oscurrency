# Only one instance of scheduler at the time. 
# Lockfile feature only works on OSes that support the flock (man 2 flock) call.
# scheduler = Rufus::Scheduler.new(:lockfile => ".task-scheduler.lock")
# 
# At the end of month on 21:00 pm - it may take some time.
# scheduler.cron '0 21 L * *' do
  # begin
    # Account.pay_transaction_cash_fees
  # rescue => e
    # $stderr.puts '-' * 80
    # $stderr.puts e.message
    # $stderr.puts e.stacktrace
    # $stderr.puts '-' * 80
  # end
# end
