class CreateFormTemplateFields < ActiveRecord::Migration[8.0]
  def change
    create_table :form_template_fields do |t|
      t.references :form_template, null: false, foreign_key: true
      t.string :field_type
      t.string :label
      t.boolean :required
      t.json :options
      t.integer :position

      t.timestamps
    end
  end
end
