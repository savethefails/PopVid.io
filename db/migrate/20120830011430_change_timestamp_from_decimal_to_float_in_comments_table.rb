class ChangeTimestampFromDecimalToFloatInCommentsTable < ActiveRecord::Migration
	def up
		change_column :comments, :timestamp, :float, :default => 0
	end

	def down
		change_column :comments, :timestamp, :integer, :default => nil
	end
end
