# features/step_definitions/student_form_steps.rb

# ==================== SETUP ====================

Dado('estou inscrito na turma {string}') do |turma_code|
  @student ||= @admin || create(:user, role: :user, email: 'student@test.com', name: 'João Estudante')
  @klass = create(:klass, code: turma_code, name: "Turma #{turma_code}", semester: '2025.1')
  create(:class_member, user: @student, klass: @klass, role: 'dicente')
end

Dado('que existe um formulário publicado {string} para minha turma') do |form_title|
  @admin ||= create(:user, role: :admin)
  @form_template = create(:form_template, name: 'Template Teste', user: @admin)
  
  # Criar campos do template
  create(:form_template_field,
    form_template: @form_template,
    label: 'Nome do aluno',
    field_type: 'text',
    required: true,
    position: 1
  )
  create(:form_template_field,
    form_template: @form_template,
    label: 'Email para contato',
    field_type: 'email',
    required: true,
    position: 2
  )
  
  @form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: form_title,
    description: 'Descrição do formulário',
    status: :published
  )
end

Dado('que já respondi {int} formulários') do |count|
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  
  @completed_forms = []
  count.times do |i|
    form = create(:form,
      form_template: @form_template,
      klass: @klass,
      title: "Formulário Respondido #{i+1}",
      status: :published
    )
    
    response = create(:form_response,
      form: form,
      user: @student,
      submitted_at: Time.current
    )
    
    @completed_forms << form
  end
end

Dado('existem {int} formulários publicados na minha turma') do |total_count|
  # Já temos alguns respondidos, criar os restantes
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  
  already_created = @completed_forms&.count || 0
  remaining = total_count - already_created
  
  remaining.times do |i|
    create(:form,
      form_template: @form_template,
      klass: @klass,
      title: "Formulário Pendente #{i+1}",
      status: :published
    )
  end
end

Dado('que existe um formulário publicado que já respondi') do
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  
  field = create(:form_template_field,
    form_template: @form_template,
    label: 'Pergunta Teste',
    field_type: 'text',
    position: 1
  )
  
  @form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: 'Formulário Já Respondido',
    status: :published
  )
  
  @form_response = create(:form_response,
    form: @form,
    user: @student,
    submitted_at: Time.current
  )
  
  create(:form_answer,
    form_response: @form_response,
    form_template_field: field,
    answer: 'Minha resposta'
  )
end

Dado('que existe um formulário publicado para a turma {string}') do |turma_code|
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  
  @other_klass = create(:klass, code: turma_code, name: "Turma #{turma_code}", semester: '2025.1')
  
  @other_form = create(:form,
    form_template: @form_template,
    klass: @other_klass,
    title: 'Formulário Outra Turma',
    status: :published
  )
end

Dado('não estou inscrito na turma {string}') do |turma_code|
  # Já não está inscrito por padrão
end

Dado('que existe um formulário em status {string} da minha turma') do |status|
  @admin ||= create(:user, role: :admin)
  @form_template ||= create(:form_template, name: 'Template Teste', user: @admin)
  create(:form_template_field, form_template: @form_template, label: 'Campo', field_type: 'text', position: 1)
  
  status_value = case status
                 when 'Rascunho' then :draft
                 when 'Fechado' then :closed
                 end
  
  @draft_or_closed_form = create(:form,
    form_template: @form_template,
    klass: @klass,
    title: "Formulário #{status}",
    status: status_value
  )
end

# ==================== NAVIGATION ====================

Quando('acesso meu dashboard de formulários') do
  visit student_forms_path
end

Quando('clico em {string} na seção de respondidos') do |link_text|
  within('section', text: 'Formulários Respondidos') do
    click_link link_text
  end
end

Quando('tento acessar esse formulário diretamente') do
  visit student_form_path(@other_form)
end

# ==================== ASSERTIONS ====================

Então('devo ver a seção {string}') do |section_title|
  expect(page).to have_content(section_title)
end

Então('devo ver o formulário {string} na lista') do |form_title|
  expect(page).to have_content(form_title)
end

Então('devo ver a página de resposta do formulário') do
  expect(page).to have_content(@form.title)
end


Então('devo ver o botão {string}') do |button_text|
  expect(page).to have_button(button_text)
end

Então('a seção de respondidos deve ter {int} formulários') do |count|
  within('section', text: 'Formulários Respondidos') do
    @completed_forms.each do |form|
      expect(page).to have_content(form.title)
    end
  end
end

Então('devo ver {string}') do |text|
  expect(page).to have_content(text)
end

Então('devo ver minhas respostas anteriores') do
  expect(page).to have_content('Suas Respostas')
  expect(page).to have_content('Minha resposta')
end

Então('o formulário não deve aparecer na lista de pendentes') do
  within('section', text: 'Formulários Pendentes') do
    expect(page).not_to have_content(@draft_or_closed_form.title)
  end
end
