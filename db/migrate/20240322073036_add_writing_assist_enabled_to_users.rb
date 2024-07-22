class AddWritingAssistEnabledToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :writing_assist_enabled, :boolean, default: true
  end
end
