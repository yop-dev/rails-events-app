class AddUserToEvents < ActiveRecord::Migration[8.0]
  def change
    # First add the column as nullable
    add_reference :events, :user, null: true, foreign_key: true
    
    # If there are existing events, assign them to the first admin user
    # (You can modify this logic based on your needs)
    reversible do |dir|
      dir.up do
        if Event.exists?
          # Find the first admin user, or create one if none exists
          admin_user = User.find_by(role: 1)
          if admin_user.nil?
            # If no admin exists, find the first user
            admin_user = User.first
          end
          
          if admin_user
            Event.update_all(user_id: admin_user.id)
          end
        end
      end
    end
    
    # Now make the column not null
    change_column_null :events, :user_id, false
  end
end
