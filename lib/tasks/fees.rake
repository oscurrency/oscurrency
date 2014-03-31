namespace :fees do
  desc "charges accounts associated with recurring fees"
  task :recurring => :environment do
    FeePlan.all.each do |p|
      p.apply_recurring_fees(ENV['INTERVAL'])
    end
    StripeFee.apply_stripe_transaction_fees(ENV['INTERVAL'])
  end
end
