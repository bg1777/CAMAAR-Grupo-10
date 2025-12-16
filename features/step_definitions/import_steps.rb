# features/step_definitions/import_steps.rb

# ==================== SETUP ====================

Dado('que existem {int} turmas importadas') do |count|
  @admin ||= create(:user, role: :admin)
  @klasses = []
  count.times do |i|
    klass = create(:klass,
      code: "CC#{1000 + i}",
      name: "Turma #{i+1}",
      semester: '2025.1'
    )
    @klasses << klass
  end
end

Dado('existem {int} alunos registrados') do |count|
  @students = []
  count.times do |i|
    student = create(:user,
      role: :user,
      email: "aluno#{i+1}@test.com",
      name: "Aluno #{i+1}",
      password: 'senha123'
    )
    @students << student
  end
end

# ==================== NAVIGATION ====================

Quando(/^acesso a página de importação \(.+\)$/) do
  visit admin_imports_path
end

Quando('acesso a página de importação') do
  visit admin_imports_path
end

Quando(/^tento acessar a página de importação \(.+\)$/) do
  visit admin_imports_path
end

# ==================== ASSERTIONS ====================

Então('devo ver o formulário de upload de arquivo') do
  expect(page).to have_field('file')
  expect(page).to have_button('Importar Turmas e Alunos')
end

Então('devo ver as instruções de importação') do
  expect(page).to have_content('Instruções de Uso')
  expect(page).to have_content('Estrutura esperada do JSON')
end

Então('devo ver {string} turmas no total') do |count|
  within('.card', text: 'Total de Turmas') do
    expect(page).to have_content(count)
  end
end

Então('devo ver {string} alunos no total') do |count|
  within('.card', text: 'Total de Alunos') do
    expect(page).to have_content(count)
  end
end
