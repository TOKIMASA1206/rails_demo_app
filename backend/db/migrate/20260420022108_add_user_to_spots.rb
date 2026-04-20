class AddUserToSpots < ActiveRecord::Migration[8.1]
  def change
    add_reference :spots, :user, foreign_key: true
  end
end
