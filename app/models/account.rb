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
  
  # def self.calculate_demmurage(accounts)
#     
  # end
  
  # Post as integers or strings. Year in 4 digit format. month can be month's name.
  def fees_invoice_for_month(month, year)
    month_string = get_by_month_string(month, year)
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
          when "percentage(trade credits)" then trade_credits_fees += (fee.amount / 100) * monthly_amount
          when "percentage(cash)" then cash_fees += (fee.amount / 100) * monthly_amount
          when "trade credits" then trade_credit_fees += monthly_amount
          when "cash" then cash_fees += monthly amount
        end  
      elsif fee.event.downcase.eql? "transaction"
        case fee.fee_type.downcase
          # Calculate percentage for each transaction and sum it up.
          when "percentage(trade credits)" then 
            amounts_array.each do |amount|
              trade_credit_fees += (fee.amount / 100) * amount
            end
          
          when "percentage(cash)" then
            amounts_array.each do |amount|
              cash_fees += (fee.amount / 100) * amount
            end
            
         # Same fee for every transaction, so just fee * transaction number   
          when "trade credits" then trade_credit_fees += fee.amount * amounts_array.count
          when "cash" then cash_fees += fee.amount * amounts_array.count
        end 
      end
      # Nice hash for user.
      return {:"trade_credits" => trade_credits_fees, :cash => cash_fees}  
    end
    
  end

  private

  def check_credit_limit 
    if credit_limit_changed?
      if (not credit_limit.nil?) and (credit_limit + balance_with_initial_offset < 0)
        raise CanCan::AccessDenied.new("Denied: Updating credit limit for #{person.display_name} would put account in prohibited state.", :update, Account)
      end
    end
  end
  
  def get_by_month_string(month, year)
    month = Date::MONTHNAMES.index(month) if month.kind_of? String and month.to_i.zero?
    "#{year.to_i}-#{month.to_i}-01"
  end
end
