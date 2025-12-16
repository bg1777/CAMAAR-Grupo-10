# features/step_definitions/form_field_steps.rb

Quando('adiciono um campo de texto com label {string}') do |label|
  page.execute_script("addField()")
  sleep 0.5
  
  within all('.field-item').last do
    select 'text', from: 'Tipo de Campo'
    fill_in 'Rótulo do Campo', with: label
  end
end

Quando('adiciono um campo de email com label {string}\(obrigatório)') do |label|
  page.execute_script("addField()")
  sleep 0.5
  
  within all('.field-item').last do
    select 'email', from: 'Tipo de Campo'
    fill_in 'Rótulo do Campo', with: label
    check 'Obrigatório?'
  end
end

Quando('adiciono um campo select com label {string} e opções {string}') do |label, options_json|
  page.execute_script("addField()")
  sleep 0.5
  
  within all('.field-item').last do
    select 'select', from: 'Tipo de Campo'
    fill_in 'Rótulo do Campo', with: label
    fill_in 'Opções (JSON)', with: options_json
  end
end

Quando('adiciono um novo campo de texto com label {string}') do |label|
  page.execute_script("addField()")
  sleep 0.5
  
  within all('.field-item').last do
    select 'text', from: 'Tipo de Campo'
    fill_in 'Rótulo do Campo', with: label
  end
end

Quando('não adiciono nenhum campo') do
  # Apenas não faz nada - deixa o campo default vazio
end

Quando('clico em {string}') do |text|
  if text == 'Adicionar Campo'
    page.execute_script("addField()")
    sleep 0.5
  elsif text == 'Marcar como obrigatório'
    within all('.field-item').last do
      check 'Obrigatório?'
    end
  else
    begin
      click_link text
    rescue
      click_button text
    end
  end
end

Quando('seleciono o tipo {string}') do |field_type|
  within all('.field-item').last do
    select field_type, from: 'Tipo de Campo'
  end
end

Quando('deixo o label vazio') do
  within all('.field-item').last do
    fill_in 'Rótulo do Campo', with: ''
  end
end

Quando('preencho o label com {string}') do |label_value|
  within all('.field-item').last do
    fill_in 'Rótulo do Campo', with: label_value
  end
end

Quando('deixo as opções vazias') do
  within all('.field-item').last do
    fill_in 'Opções (JSON)', with: ''
  end
end

Então('devo ver uma mensagem de validação sobre o label do campo') do
  expect(page).to have_content(/Label.*(não pode|can't be blank)/i)
end
