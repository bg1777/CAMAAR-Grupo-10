# features/step_definitions/admin_response_steps.rb

# ==================== SETUP ====================

Dado('que existe um formulário publicado {string}') do |form_title|
  @admin ||= create(:user, role: :admin)
  @form_template = create(:form_template, name: 'Template Teste', user: @admin)
  
  @field1 = create(:form_template_field,
    form_template: @form_template,
    label: 'Nome do aluno',
    field_type: 'text',
    required: true,
    position: 1
  )
  
  @field2 = create(:form_template_field,
    form_template: @form_template,
    label: 'Email',
    field_type: 'email',
    required: true,
    position: 2
  )
  
  @klass = create(:klass, code: 'CC001', name: 'Turma Teste', semester: '2025.1')
  
  @form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: form_title,
    description: 'Descrição',
    status: :published
  )
end

Dado('{int} alunos responderam o formulário') do |count|
  count.times do |i|
    student = create(:user,
      role: :user,
      email: "aluno#{i+1}@test.com",
      name: "Aluno #{i+1}"
    )
    
    create(:class_member, user: student, klass: @klass, role: 'dicente')
    
    response = create(:form_response,
      form: @form,
      user: student,
      submitted_at: Time.current
    )
    
    create(:form_answer,
      form_response: response,
      form_template_field: @field1,
      answer: "Resposta #{i+1}"
    )
    
    create(:form_answer,
      form_response: response,
      form_template_field: @field2,
      answer: "aluno#{i+1}@test.com"
    )
  end
end

Dado('que existe um formulário publicado com respostas') do
  step 'que existe um formulário publicado "Formulário Teste"'
end

Dado('um aluno {string} respondeu o formulário') do |student_name|
  @student = create(:user,
    role: :user,
    email: 'joao@test.com',
    name: student_name
  )
  
  create(:class_member, user: @student, klass: @klass, role: 'dicente')
  
  @response = create(:form_response,
    form: @form,
    user: @student,
    submitted_at: Time.current
  )
  
  create(:form_answer,
    form_response: @response,
    form_template_field: @field1,
    answer: 'Minha resposta detalhada'
  )
  
  create(:form_answer,
    form_response: @response,
    form_template_field: @field2,
    answer: 'joao@test.com'
  )
end

Dado('que existe um formulário publicado sem respostas') do
  step 'que existe um formulário publicado "Formulário Vazio"'
  # Não criar respostas
end

Dado('{int} alunos responderam antes de fechar') do |count|
  # Garantir que os campos existem
  unless @field1 && @field2
    @field1 = @form.form_template.form_template_fields.find_or_create_by!(
      label: 'Nome do aluno',
      field_type: 'text',
      position: 1
    )
    
    @field2 = @form.form_template.form_template_fields.find_or_create_by!(
      label: 'Email',
      field_type: 'email',
      position: 2
    )
  end
  
  count.times do |i|
    student = create(:user,
      role: :user,
      email: "aluno_fechado#{i+1}@test.com",
      name: "Aluno Fechado #{i+1}"
    )
    
    create(:class_member, user: student, klass: @form.klass, role: 'dicente')
    
    response = create(:form_response,
      form: @form,
      user: student,
      submitted_at: Time.current
    )
    
    create(:form_answer,
      form_response: response,
      form_template_field: @field1,
      answer: "Resposta #{i+1}"
    )
    
    create(:form_answer,
      form_response: response,
      form_template_field: @field2,
      answer: "aluno#{i+1}@test.com"
    )
  end
end

Dado('que existe um formulário criado por outro admin') do
  @other_admin = create(:user, role: :admin, email: 'other@admin.com', name: 'Outro Admin')
  @form_template = create(:form_template, name: 'Template Teste', user: @other_admin)
  
  create(:form_template_field,
    form_template: @form_template,
    label: 'Campo',
    field_type: 'text',
    position: 1
  )
  
  @klass = create(:klass, code: 'CC001', name: 'Turma Teste', semester: '2025.1')
  
  @form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: 'Formulário de Outro Admin',
    status: :published
  )
end

Dado('existe um formulário publicado') do
  step 'que existe um formulário publicado "Formulário Teste"'
end

# ==================== NAVIGATION ====================

Quando('acesso a página do formulário') do
  visit admin_form_path(@form)
end

Quando('clico em {string} na linha do aluno') do |link_text|
  within('tbody') do
    click_link link_text
  end
end

Quando('acesso esse formulário') do
  visit admin_form_path(@form)
end

Quando('tento acessar a página admin do formulário') do
  visit admin_form_path(@form)
end

# ==================== ASSERTIONS ====================

Então('devo ver {int} respostas na tabela') do |count|
  expect(page).to have_css('tbody tr', count: count)
end

Então('cada resposta deve ter o nome do aluno') do
  within('tbody') do
    expect(page).to have_content('Aluno 1')
  end
end

Então('cada resposta deve mostrar o status {string}') do |status|
  within('tbody') do
    expect(page).to have_content(status)
  end
end

Então('devo ver o nome {string}') do |name|
  expect(page).to have_content(name)
end

Então('devo ver a data de submissão') do
  expect(page).to have_content('Data de Resposta')
end

Então('devo ver todas as perguntas e respostas dele') do
  expect(page).to have_content('Nome do aluno')
  expect(page).to have_content('Minha resposta detalhada')
end

Então('devo ver o badge {string}') do |badge_text|
  expect(page).to have_css('.badge', text: badge_text)
end

Então('devo conseguir ver as {int} respostas coletadas') do |count|
  expect(page).to have_css('tbody tr', count: count)
end

Então('devo conseguir visualizar o formulário') do
  expect(page).to have_content(@form.title)
end

Então('devo conseguir ver as respostas') do
  expect(page).to have_content('Respostas')
end
