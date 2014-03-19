# == Schema Information
# Schema version: 20090216032013
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  balance    :decimal(8, 2)   default(0.0)
#  person_id  :integer(4)      
#  created_at :datetime        
#  updated_at :datetime        
#

class Account < ActiveRecord::Base
  extend PreferencesHelper
  belongs_to :person
  belongs_to :group

  attr_accessible :credit_limit, :offset, :reserve, :reserve_percent, :as => :admin
  attr_accessible :credit_limit, :offset, :reserve, :reserve_percent

  before_update :check_credit_limit

  INITIAL_BALANCE = 0

  def name
    unless read_attribute(:name).blank?
      read_attribute(:name)
    else
      person.display_name if person
    end
  end

  def membership
    Membership.mem(person,group)
  end

  def balance_with_initial_offset
    balance + offset
  end

  def authorized?(amount)
    credit_limit.nil? or (amount <= balance_with_initial_offset + credit_limit)
  end

  def withdraw(amount)
    self.paid += amount
    adjust_balance_and_save(-amount)
  end

  def withdraw_and_decrement_earned(amount)
    self.earned -= amount
    adjust_balance_and_save(-amount)
  end

  def deposit(amount)
    self.earned += amount
    adjust_balance_and_save(amount)
  end

  def deposit_and_decrement_paid(amount)
    self.paid -= amount
    adjust_balance_and_save(amount)
  end

  def adjust_balance_and_save(amount)
    self.balance += amount
    save!
  end

  def self.transfer(from, to, amount, metadata)
    transaction do
      exchange = ExchangeAndFee.new()
      exchange.customer = from
      exchange.worker = to
      exchange.amount = amount
      exchange.metadata = metadata
      # XXX maybe cleaner to let the exchange object assign group_id itself?
      exchange.group_id = metadata.group.adhoc_currency? ? metadata.group_id : global_prefs.default_group_id
      # permission depends on current_user and policy of group specified in request
      if metadata.ability.can? :create, exchange
        exchange.save!
      else
        raise CanCan::AccessDenied.new("Payment declined.", :create, Exchange)
      end
    end
  end
 
 
 ##### CODE FROM THE PAST #####
 
  # # Yearly fees
  # def self.pay_yearly_fees
    # # Get string for by_year scope.
    # year_string = get_by_month_string(1, Date.today.year)
    # admin_account = Account.includes(:person).where('lower(people.name) = ?', "admin").first
    # reserve_account = Account.includes(:person).where('lower(people.name) = ?', "reserve").first
    # # Go through all accounts and withdraw cash fees.
    # Account.all.each do |account|
      # admin_tc_fees_sum = 0
      # admin_cash_fees_sum = 0 
      # reserve_tc_fees_sum = 0
      # reserve_cash_fees_sum = 0
      # # Sum of all user's transactions for this year.
      # yearly_amount = Exchange.where(:customer_id => account.person_id).by_year(year_string).sum(:amount)
      # # Yearly fees
      # unless account.person.plan_type.nil? or account.person.plan_type.fees.blank? 
        # account.person.plan_type.fees.where("lower(event) = ?", "yearly").each do |y_fee|
          # if y_fee.account.downcase.eql? "admin"
            # case y_fee.fee_type.downcase
              # when "percentage(trade credits)" then admin_tc_fees_sum += y_fee.amount.to_percents * yearly_amount
              # when "percentage(cash)" then admin_cash_fees_sum += y_fee.amount.to_percents * yearly_amount
              # when "trade credits" then admin_tc_fees_sum += y_fee.amount
              # when "cash" then admin_cash_fees_sum += y_fee.amount
            # end 
          # elsif y_fee.account.downcase.eql? "reserve"
            # case y_fee.fee_type.downcase
              # when "percentage(trade credits)" then reserve_tc_fees_sum += y_fee.amount.to_percents * yearly_amount
              # when "percentage(cash)" then reserve_cash_fees_sum += y_fee.amount.to_percents * yearly_amount
              # when "trade credits" then reserve_tc_fees_sum += y_fee.amount
              # when "cash" then reserve_cash_fees_sum += y_fee.amount
            # end
          # else
            # raise "Wrong fee account for fee id:#{y_fee.id}. Neither 'admin' nor 'reserve'."
          # end
        # end
      # end
      # # Trade credits payment.
      # account.withdraw(admin_tc_fees_sum + reserve_tc_fees_sum)
      # admin_account.deposit(admin_tc_fees_sum)
      # reserve_account.deposit(reserve_tc_fees_sum)
      # # STRIPE
      # # account pay admin_cash_fees_sum + reserve_cash_fees_sum
      # # admin-account deposit admin_cash_fees_sum
      # # reserve-account deposit reserve_cash_fees_sum
    # end
#     
  # end
#  
  # # Monthly fees
  # def self.pay_monthly_fees
    # # Get string for by_month scope.
    # month_string = get_by_month_string(Date.today.month, Date.today.year)
    # admin_account = Account.includes(:person).where('lower(people.name) = ?', "admin").first
    # reserve_account = Account.includes(:person).where('lower(people.name) = ?', "reserve").first
    # # Go through all accounts and withdraw cash fees.
    # Account.all.each do |account|
      # admin_tc_fees_sum = 0
      # admin_cash_fees_sum = 0 
      # reserve_tc_fees_sum = 0
      # reserve_cash_fees_sum = 0
      # # Sum of all user's transactions for this month.
      # monthly_amount = Exchange.where(:customer_id => account.person_id).by_month(month_string).sum(:amount)
      # # Monthly fees
      # unless account.person.plan_type.nil? or account.person.plan_type.fees.blank? 
        # account.person.plan_type.fees.where("lower(event) = ?", "monthly").each do |m_fee|
          # if m_fee.account.downcase.eql? "admin"
            # case m_fee.fee_type.downcase
              # when "percentage(trade credits)" then admin_tc_fees_sum += m_fee.amount.to_percents * monthly_amount
              # when "percentage(cash)" then admin_cash_fees_sum += m_fee.amount.to_percents * monthly_amount
              # when "trade credits" then admin_tc_fees_sum += m_fee.amount
              # when "cash" then admin_cash_fees_sum += m_fee.amount
            # end 
          # elsif m_fee.account.downcase.eql? "reserve"
            # case m_fee.fee_type.downcase
              # when "percentage(trade credits)" then reserve_tc_fees_sum += m_fee.amount.to_percents * monthly_amount
              # when "percentage(cash)" then reserve_cash_fees_sum += m_fee.amount.to_percents * monthly_amount
              # when "trade credits" then reserve_tc_fees_sum += m_fee.amount
              # when "cash" then reserve_cash_fees_sum += m_fee.amount
            # end
          # else
            # raise "Wrong fee account for fee id:#{m_fee.id}. Neither 'admin' nor 'reserve'."
          # end
        # end
      # end
      # # Trade credits payment.
      # account.withdraw(admin_tc_fees_sum + reserve_tc_fees_sum)
      # admin_account.deposit(admin_tc_fees_sum)
      # reserve_account.deposit(reserve_tc_fees_sum)
      # # STRIPE
      # # account pay admin_cash_fees_sum + reserve_cash_fees_sum
      # # admin-account deposit admin_cash_fees_sum
      # # reserve-account deposit reserve_cash_fees_sum
    # end
  # end

  # Cash fees are aggregated and submitted to credit card processing in batches. 
  # Currently, weekly to Stripe. 
  def self.pay_transaction_cash_fees
    week_interval = Date.today.beginning_of_week.strftime("%d %B, %Y") + ' - ' +
                    Date.today.end_of_week.strftime("%d %B, %Y")
    desc = "Transaction fees sum for week: #{week_interval}"            
    Person.with_stripe_plans.each do |person|
      customer_card = Stripe::Customer.retrieve(person.stripe_id).cards.first.id 
      # Sum all fees-per-transaction amounts
      fees_sum = person.fee_plan.fixed_transaction_stripe_fees.sum(:amount)
      # Take number of transactions
      transactions_count = person.transactions.where(:customer_id => person.id).count
      unless fees_sum.zero? || transactions_count.zero?
        # For each transaction take a fee:
        Stripe::Charge.create(
          :amount => (fees_sum * transactions_count).to_cents,
          :currency => "usd",
          :card => customer_card,
          :description => desc
        )
      end
      # Sum all percentage-fees-per-transaction percentages
      fees_perc_sum = (person.fee_plan.percent_transaction_stripe_fees.sum(:percent)).to_percents
      unless fees_perc_sum.zero? 
        # For each transaction take a fee:
        person.transactions.where(:customer_id => person.id).each do |transaction|
          Stripe::Charge.create(
            :amount => (fees_perc_sum * transaction.amount).to_cents,
            :currency => "usd",
            :card => customer_card,
            :description => desc
          )
        end
      end
    end
  end
  
  # Post as integers or strings. Year in 4 digit format. month can be month's name.
  def fees_invoice_for_month(month, year)
    month_string = Account.get_by_month_string(month, year)
    trade_credit_fees = 0
    cash_fees = 0    
    # User exchanges for given month.
    user_exchanges = Exchange.where(:customer_id => person_id).by_month(month_string)
    # Array of amounts of transactions.
    amounts_array = user_exchanges.map{ |transaction| transaction.amount }
    # Sum of transictions for given month.
    monthly_amount = user_exchanges.sum(:amount)

    person.plan_type.fees.each do |fee|
      if fee.event.downcase.eql? "monthly"
        case fee.fee_type.downcase
          when "percentage(trade credits)" then trade_credit_fees += fee.amount.to_percents * monthly_amount
          when "percentage(cash)" then cash_fees += fee.amount.to_percents * monthly_amount
          when "trade credits" then trade_credit_fees += monthly_amount
          when "cash" then cash_fees += monthly_amount
        end  
      elsif fee.event.downcase.eql? "transaction"
        case fee.fee_type.downcase
          # Calculate percentage for each transaction and sum it up.
          when "percentage(trade credits)" then 
            amounts_array.each do |amount|
              trade_credit_fees += fee.amount.to_percents * amount
            end
          
          when "percentage(cash)" then
            amounts_array.each do |amount|
              cash_fees += fee.amount.to_percents * amount
            end
            
         # Same fee for every transaction, so just fee * transaction number   
          when "trade credits" then trade_credit_fees += fee.amount * amounts_array.count
          when "cash" then cash_fees += fee.amount * amounts_array.count
        end 
      end
    end
    # Nice hash for user.
    return {:"trade-credits" => trade_credit_fees, :cash => cash_fees}  
  end
  
  def self.get_by_month_string(month, year)
    month = Date::MONTHNAMES.index(month.capitalize) if month.kind_of? String and month.to_i.zero?
    "#{year.to_i}-#{month.to_i}-01"
  end

  private

  def check_credit_limit 
    if credit_limit_changed?
      if (not credit_limit.nil?) and (credit_limit + balance_with_initial_offset < 0)
        raise CanCan::AccessDenied.new("Denied: Updating credit limit for #{person.display_name} would put account in prohibited state.", :update, Account)
      end
    end
  end
  
end
