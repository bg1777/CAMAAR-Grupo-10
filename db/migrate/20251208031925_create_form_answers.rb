class CreateFormAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :form_answers do |t|
      t.references :form_response, null: false, foreign_key: true
      t.references :form_template_field, null: false, foreign_key: true
      t.text :answer

      t.timestamps
    end
  end
end
