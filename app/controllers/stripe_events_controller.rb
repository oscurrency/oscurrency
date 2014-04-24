class StripeEventsController < ApplicationController
  before_filter :parse_and_validate_event

  def create
    if self.class.private_method_defined? event_method
      self.send(event_method, @event.event_object)
    end
    render nothing: true
  end

  private

  def event_method
    "stripe_#{@event.stripe_type.gsub('.','_')}".to_sym
  end

  def parse_and_validate_event
    Rails.logger.info "parse_and_validate_event stripe_id: #{params[:id]}, stripe_type: #{params[:type]}"
    @event = StripeEvent.new(stripe_id: params[:id], stripe_type: params[:type])
    unless @event.save
      if @event.valid?
        render nothing: true, status: 400 # try again later
      else
        render nothing: true
      end
    end
  end

  def stripe_plan_deleted(plan)
    Rails.logger.info "stripe_plan_deleted: #{plan.id}"
    RecurringStripeFee.where(plan: plan.id).each do |stripe_fee|
      fee_plan = stripe_fee.fee_plan
      Rails.logger.info "disabling fee plan: #{fee_plan.name}"
      fee_plan.enabled = false
      fee_plan.save!
    end
  end
end
