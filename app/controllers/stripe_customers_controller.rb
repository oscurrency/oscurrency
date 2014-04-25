class StripeCustomersController < ApplicationController
  def new
    unless current_person
      flash[:notice] = t('notice_login_required')
      redirect_to login_url
    end

    unless current_person.fee_plan
      flash[:notice] = 'You do not have a fee plan.'
      redirect_to group_path(current_person.default_group)
    else
      @recurring_stripe_fees = current_person.fee_plan.recurring_stripe_fees
    end
  end

  def create
    @recurring_stripe_fees = current_person.fee_plan.recurring_stripe_fees
    Rails.logger.info "XXX stripe card token: #{params[:stripe_card_token]}"
    if params[:stripe_card_token].present?
      # assuming a customer will only need to sign up to one plan
      if @recurring_stripe_fees.length > 1
        flash[:error] = 'Somehow the plan you are on has more than one stripe fee. This makes no sense.'
        render :action => :new
      end
      if @recurring_stripe_fees.length == 0
        flash[:error] = 'The plan you are on does not have a credit card fee.'
        render :action => :new
      end
      customer = Stripe::Customer.create(card: params[:stripe_card_token], plan: @recurring_stripe_fees[0].plan, description: "Person #{current_person.id}")
      Rails.logger.info "XXX customer: #{customer.inspect}"
      current_person.stripe_customer_token = customer.id
      current_person.save
      flash[:notice] = 'Success.'
      redirect_to group_path(current_person.default_group)
    else
      flash[:error] = 'oops!'
      Rails.logger.info "XXX stripe did not return a token."
      render :action => :new
    end
  rescue Stripe::AuthenticationError
    Rails.logger.info "XXX stripe auth error."
    # XXX probably want to email admin.
    flash[:error] = 'stripe auth error!'
    render :action => :new
  rescue Stripe::InvalidRequestError => e
    Rails.logger.info "XXX invalid request error: #{e.message}"
    flash[:error] = 'stripe invalid request error!'
    render :action => :new
  rescue Stripe::CardError => e
    Rails.logger.info "XXX stripe card error: #{e.message}"
    flash[:error] = 'stripe card error!'
    render :action => :new
  end
end
