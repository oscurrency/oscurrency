require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminAddToMailchimpList
end

module RailsAdmin
  module Config
    module Actions
      class RefundMoney < RailsAdmin::Config::Actions::Base      
        
        register_instance_option :visible? do
          authorized? && bindings[:object].status != 'refunded'
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-repeat'
        end

        register_instance_option :controller do
         Proc.new do
          # XXX railsadmin UI is sending http request twice. ignore the redundant pjax request.
          unless request.headers['X-PJAX']
            flash[:alert] = StripeOps.refund_charge(@object.stripe_id)
            redirect_to back_or_index
          end
         end
        end
      end
      
         
   end
 end
end