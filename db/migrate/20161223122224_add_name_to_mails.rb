class AddNameToMails < ActiveRecord::Migration
  def change
  	add_column :emails, :user_name, :string
  end
end
