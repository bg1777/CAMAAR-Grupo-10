Então('devo ser redirecionado para o dashboard admin') do
  expect(current_path).to eq(admin_root_path)
  # Reforça verificando um elemento único da admin dashboard
  expect(page).to have_content('Painel Administrativo') 
end

Então('devo ser redirecionado para o dashboard estudante') do
  expect(current_path).to eq(root_path)
  # Reforça verificando elemento da home do estudante
  expect(page).to have_content('Formulários Pendentes')
end

Então('devo permanecer na página de login') do
  expect(current_path).to eq(new_user_session_path)
end

Então('devo ver meus formulários pendentes') do
  # Verifica a seção específica da view home/index.html.erb
  expect(page).to have_content('Formulários Pendentes')
end
