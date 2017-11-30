class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :code
      t.string :nickName
      t.string :phone
      t.string :openid
      t.boolean :gender
      t.string :avatarUrl
      t.references :department, foreign_key: true
      t.text :remark

      t.timestamps
    end
    
    add_index :users, :openid
    add_index :users, :name
  end
end
