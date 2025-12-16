# features/step_definitions/form_steps.rb

# ==================== SETUP ====================

Dado('existe um template de formulário chamado {string}') do |template_name|
  @admin ||= create(:user, role: :admin, name: 'Admin User')
  @form_template = create(:form_template,
    name: template_name,
    description: 'Template de teste',
    user: @admin
  )
  create(:form_template_field,
    form_template: @form_template,
    label: 'Campo Teste',
    field_type: 'text',
    position: 1
  )
end

Dado('existe uma turma {string} com {int} alunos registrados') do |turma_code, student_count|
  @klass = create(:klass, code: turma_code, name: "Turma #{turma_code}", semester: '2025.1')
  
  @students = []
  student_count.times do |i|
    student = create(:user, role: :user, email: "aluno#{i+1}@test.com", name: "Aluno #{i+1}")
    create(:class_member, user: student, klass: @klass, role: 'dicente')
    @students << student
  end
end

Dado('que existe um formulário em status {string}') do |status|
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  @klass ||= create(:klass, code: 'CC001', name: 'Turma Teste', semester: '2025.1')
  
  status_value = case status
                 when 'Rascunho' then :draft
                 when 'Publicado' then :published
                 when 'Fechado' then :closed
                 end
  
  @form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: 'Formulário Teste',
    description: 'Descrição teste',
    status: status_value
  )
end

Dado('que existe um formulário em status {string} com título {string}') do |status, title|
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  @klass ||= create(:klass, code: 'CC001', name: 'Turma Teste', semester: '2025.1')
  
  status_value = case status
                 when 'Rascunho' then :draft
                 when 'Publicado' then :published
                 when 'Fechado' then :closed
                 end
  
  @form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: title,
    description: 'Descrição teste',
    status: status_value
  )
  @original_title = title
end

Dado('que existem {int} formulários criados') do |count|
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  @klass ||= create(:klass, code: 'CC001', name: 'Turma Teste', semester: '2025.1')
  
  @forms = []
  count.times do |i|
    form = create(:form,
      form_template: @form_template,
      klass: @klass,
      title: "Formulário #{i+1}",
      description: 'Descrição',
      status: :draft
    )
    @forms << form
  end
end

# ==================== NAVIGATION ====================

Quando(/^acesso a página de formulários \(.+\)$/) do
  visit admin_forms_path
end

Quando('acesso a página de formulários') do
  visit admin_forms_path
end

Quando('acesso a página de criação de formulário') do
  visit new_admin_form_path
end

Quando('acesso o formulário na página show') do
  visit admin_form_path(@form)
end

Quando(/^tento acessar a página de criação de formulário \(.+\)$/) do
  visit new_admin_form_path
end

# ==================== ACTIONS ====================

Quando('seleciono o template {string}') do |template_name|
  select template_name, from: 'Template'
end

Quando('seleciono a turma {string}') do |turma_code|
  select turma_code, from: 'Turma'
end

Quando('preencho o título com {string}') do |title|
  fill_in 'Título do Formulário', with: title
  @form_title = title
end

# REMOVA ESTA LINHA DUPLICADA:
# Quando('preencho a descrição com {string}') do |description|
#   fill_in 'Descrição', with: description
# end

Quando('deixo o título vazio') do
  fill_in 'Título do Formulário', with: ''
end

Quando('altero o título para {string}') do |new_title|
  fill_in 'Título do Formulário', with: new_title
  @new_title = new_title
end

# ==================== ASSERTIONS ====================

Então('o formulário deve estar com status {string}') do |status|
  expect(page).to have_content(status)
end

Então('o formulário deve estar listado na página de formulários') do
  visit admin_forms_path
  expect(page).to have_content(@form_title || 'Formulário Teste')
end

Então('o formulário deve ter status {string}') do |status|
  expect(page).to have_content(status)
end

Então('devo ver todos os {int} formulários listados') do |count|
  @forms.each do |form|
    expect(page).to have_content(form.title)
  end
end

Então('o formulário não deve ser criado') do
  expect(current_path).to eq(admin_forms_path)
end

Então('o formulário deve ter o novo título {string}') do |new_title|
  expect(page).to have_content(new_title)
end

Então('não devo ver o botão {string}') do |button_text|
  expect(page).not_to have_button(button_text)
  expect(page).not_to have_link(button_text)
end
