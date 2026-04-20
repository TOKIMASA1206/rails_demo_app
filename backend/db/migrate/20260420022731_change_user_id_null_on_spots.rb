class ChangeUserIdNullOnSpots < ActiveRecord::Migration[8.1]
  def change
    change_column_null :spots, :user_id, false
  end
end
