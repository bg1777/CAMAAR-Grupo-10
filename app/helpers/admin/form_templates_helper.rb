# app/helpers/admin/form_templates_helper.rb

module Admin::FormTemplatesHelper
  def link_to_add_fields(name, form, association, **options)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render('form_template_field_form', f: builder)
    end
    
    link_to name, '#', 
      onclick: "add_fields(this, '#{association}', '#{j(fields)}'); return false;",
      class: options[:class]
  end
end
