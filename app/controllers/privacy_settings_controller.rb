class PrivacySettingsController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource

  def update
    respond_to do |format|
      if @privacy_setting.update_attributes(privacy_setting_params)
        flash[:notice] = t('notice_privacy_settings_updated')
        format.js
      else
        flash[:error] = t('error_invalid_action')
        format.js
      end
    end
  end

  private
    def privacy_setting_params
      params.require(:privacy_setting).permit(:viewable_reqs, :viewable_offers, :viewable_forum, :viewable_members)
    end
end
