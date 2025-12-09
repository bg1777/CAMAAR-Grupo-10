class CreateForms < ActiveRecord::Migration[8.0]
  def change
    create_table :forms do |t|
      t.references :form_template, null: false, foreign_key: true
      t.references :klass, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :due_date
      t.integer :status

      t.timestamps
    end
  end
end
