class AddS3Keys < ActiveRecord::Migration
  def self.up
      add_column :documents, :s3_key, :string
  end

  def self.down
      remove_column :documents,  :s3_key
  end
end