class AddFeedbackToDiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :diaries, :feedback, :text
  end
end
