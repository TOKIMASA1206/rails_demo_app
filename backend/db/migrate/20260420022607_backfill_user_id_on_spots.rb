class BackfillUserIdOnSpots < ActiveRecord::Migration[8.1]
  class MigrationUser < ApplicationRecord
    self.table_name = "users"
  end

  class MigrationSpot < ApplicationRecord
    self.table_name = "spots"
  end

  def up
    default_user = MigrationUser.find_or_create_by!(name: "Default User")
    MigrationSpot.where(user_id: nil).update_all(user_id: default_user.id)
  end

  def down
    default_user = MigrationUser.find_by(name: "Default User")
    return unless default_user

    MigrationSpot.where(user_id: default_user.id).update_all(user_id: nil)
    default_user.destroy!
  end
end
