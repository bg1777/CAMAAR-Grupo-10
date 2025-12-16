# Limpeza explícita do banco (embora o DatabaseCleaner no env.rb já faça isso automaticamente entre cenários)
Dado('que o banco de dados está limpo') do
  DatabaseCleaner.clean_with(:truncation)
end

# Step genérico para criar usuários (admin ou dicente/user)
# Converte a tabela vertical do Gherkin em atributos do FactoryBot
Dado('um usuário {word} existe com:') do |perfil, table|
  # Converte a tabela key/value do Gherkin para um hash Ruby
  attributes = table.rows_hash
  
  # Tratamento de chaves para bater com o model/factory
  user_attributes = {}
  
  attributes.each do |key, value|
    case key
    when 'senha', 'senha123' # Mapeia "senha" do Gherkin para "password" do Devise
      user_attributes[:password] = value
      user_attributes[:password_confirmation] = value
    when 'matricula'
      # Se a senha for a matrícula (conforme seu cenário de dicente), ajustamos aqui
      user_attributes[:matricula] = value
      # Se a senha não foi definida explicitamente, usa a matrícula como senha
      user_attributes[:password] ||= value
      user_attributes[:password_confirmation] ||= value
    when 'nome'
      user_attributes[:name] = value
    else
      user_attributes[key.to_sym] = value
    end
  end

  # Define o role com base na palavra usada no step (admin ou dicente)
  role = (perfil == 'admin') ? :admin : :user
  
  # Cria o usuário usando a Factory
  create(:user, role: role, **user_attributes)
end