class CreateRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :registrations do |t|
      t.references :event, null: false, foreign_key: true
      t.string :attendee_name, null: false
      t.string :attendee_email, null: false

      t.timestamps
    end
  end
end
