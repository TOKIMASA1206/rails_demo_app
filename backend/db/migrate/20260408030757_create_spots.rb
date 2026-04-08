class CreateSpots < ActiveRecord::Migration[8.1]
  def change
    create_table :spots do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :note
      t.string :url
      t.string :status, null: false, default: "want_to_go"
      t.date :visited_on

      t.timestamps
    end

    add_index :spots, :status
    add_check_constraint :spots, "status IN ('want_to_go', 'visited')", name: "spots_status_check"
  end
end
