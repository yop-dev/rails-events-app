class UpdateExistingEventsDescriptions < ActiveRecord::Migration[8.0]
  def up
    # Update any existing events that have blank or null descriptions
    Event.where(description: [nil, '']).find_each do |event|
      event.update_column(:description, 'Event description to be updated.')
    end
  end

  def down
    # This migration is not reversible as we can't know the original blank state
    raise ActiveRecord::IrreversibleMigration
  end
end
