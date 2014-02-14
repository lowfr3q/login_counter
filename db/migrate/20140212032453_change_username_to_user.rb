class ChangeUsernameToUser < ActiveRecord::Migration
	def up
		change_table :users do |t|
			t.rename :username, :user
		end
	end

	def down
		change_table :users do |t|
			t.rename :user, :username
		end
	end
end

