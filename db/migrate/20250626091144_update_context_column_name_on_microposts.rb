class UpdateContextColumnNameOnMicroposts < ActiveRecord::Migration[7.2]
  def change
    rename_column :microposts, :context, :content
  end
end
