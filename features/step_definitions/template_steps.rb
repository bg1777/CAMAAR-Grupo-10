# features/step_definitions/template_steps.rb

# ==================== BACKGROUND/SETUP ====================

Dado('que sou um usuário admin autenticado') do
  Capybara.reset_sessions!
  @admin = create(:user, role: :admin, email: 'admin@test.com', password: 'senha123', name: 'Admin User')
  visit new_user_session_path
  fill_in 'Email', with: @admin.email
  fill_in 'Password', with: 'senha123'
  click_button 'Log in'
  expect(page).to have_content('Painel Administrativo')
end

Dado('que sou um usuário dicente autenticado') do
  Capybara.reset_sessions!
  @student = create(:user, role: :user, email: 'student@test.com', password: 'senha123', name: 'João Estudante')
  visit new_user_session_path
  fill_in 'Email', with: @student.email
  fill_in 'Password', with: 'senha123'
  click_button 'Log in'
  expect(page).to have_content('Formulários Pendentes')
end

Dado('que existe um template chamado {string}') do |template_name|
  @admin ||= create(:user, role: :admin, name: 'Admin User')
  @template = create(:form_template, 
    name: template_name, 
    description: 'Template de teste',
    user: @admin
  )
  create(:form_template_field, 
    form_template: @template,
    label: 'Campo Teste',
    field_type: 'text',
    position: 1
  )
end

Dado('que existem {int} templates criados pelo admin') do |count|
  @admin ||= create(:user, role: :admin, name: 'Admin User')
  @templates = []
  count.times do |i|
    template = create(:form_template, 
      name: "Template #{i+1}",
      description: "Descrição do template #{i+1}",
      user: @admin
    )
    create(:form_template_field,
      form_template: template,
      label: 'Campo',
      field_type: 'text',
      position: 1
    )
    @templates << template
  end
end

# ==================== NAVIGATION ====================

Quando('acesso a página de templates de formulários\({string})') do |_path|
  visit admin_form_templates_path
end

Quando('acesso a página de templates') do
  visit admin_form_templates_path
end

Quando('acesso a página de criação de template') do
  visit new_admin_form_template_path
end

Quando('acesso o template') do
  visit admin_form_template_path(@template)
end

Quando(/^tento acessar a página de criação de template \(.+\)$/) do
  visit new_admin_form_template_path
end

# ==================== ACTIONS ====================

Quando('preencho o nome com {string}') do |name|
  fill_in 'Nome do Template', with: name
  @template_name = name
end

Quando('preencho a descrição com {string}') do |description|
  fill_in 'Descrição', with: description
end

Quando('deixo o nome vazio') do
  fill_in 'Nome do Template', with: ''
end

Quando('deixo a descrição vazia') do
  fill_in 'Descrição', with: ''
end

Quando('altero o nome para {string}') do |new_name|
  fill_in 'Nome do Template', with: new_name
  @new_template_name = new_name
end

# ==================== ASSERTIONS ====================

Então('devo ser redirecionado para a página do template') do
  expect(current_path).to match(%r{/admin/form_templates/\d+})
end

Então('o template deve estar listado na página de templates') do
  visit admin_form_templates_path
  expect(page).to have_content(@template_name || 'Pesquisa de Satisfação')
end

Então('o template deve ter o novo nome') do
  expect(page).to have_content(@new_template_name || 'Pesquisa de Satisfação - v2')
end

Então('o novo campo deve estar presente') do
  expect(page).to have_content('Comentários')
end

Então('o template não deve estar mais listado') do
  visit admin_form_templates_path
  expect(page).not_to have_content('Pesquisa Antiga')
end

Então('devo ver todos os {int} templates listados') do |count|
  @templates.each do |template|
    expect(page).to have_content(template.name)
  end
end

Então('o template não deve ser criado') do
  # Verifica que permanece na página de POST (não redireciona para show)
  expect(current_path).to eq(admin_form_templates_path)
end

Então('devo ser redirecionado para a página inicial') do
  expect(current_path).to eq(root_path)
end
