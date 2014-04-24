class AddEnabledToFeePlans < ActiveRecord::Migration
  def change
    add_column :fee_plans, :enabled, :boolean, :default => true
  end
end
