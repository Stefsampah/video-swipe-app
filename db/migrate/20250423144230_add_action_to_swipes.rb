class AddActionToSwipes < ActiveRecord::Migration[7.1]
  def change
    add_column :swipes, :action, :string
  end
end
