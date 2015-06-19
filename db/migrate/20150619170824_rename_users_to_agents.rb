class RenameUsersToAgents < ActiveRecord::Migration
  def change
    rename_table :users, :agents
  end
end
