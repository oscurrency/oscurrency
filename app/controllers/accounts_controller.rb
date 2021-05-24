class AccountsController < ApplicationController
  before_filter :login_required
  load_resource :person
  authorize_resource :account, :through => :person

  def index
  end

  def update
    @account = Account.find(params[:account_id])
    if @account.update_attributes(account_params)
      flash[:success] = t('success_account_updated')
      redirect_to(edit_membership_path(@account.membership))
    else
      flash[:error] = t('error_account_update_failed')
      redirect_to(edit_membership_path(@account.membership))
    end
  end

  def show
    @account = Account.find(params[:id])
    unless (@account.group.private_txns? and not current_person?(@person))
      @exchanges = @person.received_group_exchanges(@account.group_id)
    end
    respond_to do |format|
      format.html
      format.js {render :action => 'reject' if not request.xhr?}
    end
  end

  private

    def account_params
      params.require(:account).permit(:credit_limit, :offset, :reserve, :reserve_percent)
    end
end
