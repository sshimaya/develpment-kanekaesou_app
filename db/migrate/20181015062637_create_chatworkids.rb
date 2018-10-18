class CreateChatworkids < ActiveRecord::Migration[5.2]
  def change
    create_table :chatworkids do |t|
      t.integer :p_id
      t.integer :cwid
      t.integer :trid
      t.string :name

      t.timestamps
    end
  end
end
