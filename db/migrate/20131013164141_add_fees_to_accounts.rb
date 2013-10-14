class AddFeesToAccounts < ActiveRecord::Migration
  def change
   add_column :accounts, :fees, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
