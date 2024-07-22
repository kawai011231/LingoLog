class AddDateToDiaries < ActiveRecord::Migration[7.0]
  def change
    add_column :diaries, :date, :date
  end
end
