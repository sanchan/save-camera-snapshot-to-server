class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :cover_image_uid
      t.string :cover_image_name

      t.timestamps
    end
  end
end
