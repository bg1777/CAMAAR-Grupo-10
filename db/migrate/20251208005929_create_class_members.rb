class CreateClassMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :class_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :klass, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
