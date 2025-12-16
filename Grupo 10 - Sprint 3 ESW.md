# Grupo 10 - Sprint 3 ESW

### Grupo 10 - Engenharia de Software:

Bernardo Gomes Rodrigues - 231034190

Isaac Silva - 231025216

Filipe Abadia Marcelino - 190087161

Maria Carolina Burgum Abreu Jorge - 231013547

Link de Visualização no Notion: https://www.notion.so/Grupo-10-Sprint-3-ESW-2cb7274feb388008842fc0bd122e5fd0?source=copy_link

---

## 1. Avaliando o ABC score com o rubycritic

Precisamos avaliar o ABC score e garantir que ele seja menor que 20 para todos os métodos. Ao rodar o rubycritic inicialmente, recebemos o seguinte retorno:

```ruby
bgrod@Bernardo:~/sprint3/CAMAAR-Grupo-10$ bundle exec rubycritic
running flay smells
..........................................
running flog smells
........................................................................................................
running reek smells
........................................................................................................
running complexity
........................................................................................................
running attributes
........................................................................................................
running churn
........................................................................................................
running simple_cov
.....................Warning: coverage data provided by Coverage [30] exceeds number of lines in /home/bgrod/sprint3/CAMAAR-Grupo-10/app/models/form_template_field.rb [29]
...................................................................................
New critique at file:////home/bgrod/sprint3/CAMAAR-Grupo-10/tmp/rubycritic/overview.html
Score: 74.51
```

Ou seja, foi uma análise bem sucedida. Ao executar um comando do flog para mostrar todos os métodos com ABC score maior que 40, obtemos a saída:

```ruby
# Comando do Flog

bundle exec flog -a app/ | awk '
BEGIN { 
  print "\n═══════════════════════════════════════════════════════════════════════════════"
  print "                      ANÁLISE ABC SCORE - TODOS OS MÉTODOS"
  print "═══════════════════════════════════════════════════════════════════════════════\n"
  high=0; medium=0; good=0;
}
NR<=2 { next }
/^[[:space:]]+[0-9]+\.[0-9]+:/ { 
  score = $1+0;
  sub(/^[[:space:]]+[0-9]+\.[0-9]+:[[:space:]]*/, "");
  
  if (score > 20) { 
    printf "🔴 ALTO   %5.1f │ %s\n", score, $0;
    high++;
  } else if (score > 15) { 
    printf "🟡 MÉDIO  %5.1f │ %s\n", score, $0;
    medium++;
  } else if (score > 0) { 
    printf "🟢 BOM    %5.1f │ %s\n", score, $0;
    good++;
  }
}
END {
  print "\n═══════════════════════════════════════════════════════════════════════════════"
  printf "📊 RESUMO: 🔴 %d alto (>20) │ 🟡 %d médio (>15) │ 🟢 %d bom (≤15)\n", high, medium, good;
  print "═══════════════════════════════════════════════════════════════════════════════\n"
}'
```

```ruby
# Saída

═══════════════════════════════════════════════════════════════════════════════
                      ANÁLISE ABC SCORE - TODOS OS MÉTODOS
═══════════════════════════════════════════════════════════════════════════════

🔴 ALTO    43.7 │ Admin::ImportsController#import_klasses app/controllers/admin/imports_controller.rb:13-44
🔴 ALTO    23.6 │ Admin::FormsController#create    app/controllers/admin/forms_controller.rb:25-45
🔴 ALTO    20.6 │ ImportService#find_or_create_user app/services/import_service.rb:74-101
🟡 MÉDIO   16.5 │ Student::FormsController#answer  app/controllers/student/forms_controller.rb:20-37
🟢 BOM     14.9 │ Admin::FormTemplatesController#create app/controllers/admin/form_templates_controller.rb:21-32
🟢 BOM     14.8 │ Admin::FormTemplatesHelper#link_to_add_fields app/helpers/admin/form_templates_helper.rb:4-14
🟢 BOM     14.4 │ Student::FormsController#submit_answer app/controllers/student/forms_controller.rb:39-52
🟢 BOM     13.5 │ FormResponse#build_answers_for_fields app/models/form_response.rb:23-29
🟢 BOM     13.3 │ HomeController#index             app/controllers/home_controller.rb:6-13
🟢 BOM     13.0 │ User#pending_forms               app/models/user.rb:29-35
🟢 BOM      9.8 │ ImportService#import_single_klass app/services/import_service.rb:35-44
🟢 BOM      9.6 │ Form#none
🟢 BOM      9.3 │ ImportService#find_or_create_klass app/services/import_service.rb:46-54
🟢 BOM      9.0 │ FormTemplateField#none
🟢 BOM      8.9 │ Student::FormsController#check_form_accessible app/controllers/student/forms_controller.rb:64-68
🟢 BOM      8.6 │ Admin::FormsController#update    app/controllers/admin/forms_controller.rb:52-60
🟢 BOM      8.4 │ Klass#none
🟢 BOM      8.3 │ User#none
🟢 BOM      7.6 │ Form#pending_responses           app/models/form.rb:18-20
🟢 BOM      7.6 │ FormTemplateField#ensure_position_is_integer app/models/form_template_field.rb:26-28
🟢 BOM      7.5 │ Student::FormsController#index   app/controllers/student/forms_controller.rb:10-13
🟢 BOM      7.4 │ ImportService#import_single_student app/services/import_service.rb:64-72
🟢 BOM      7.0 │ FormResponse#none
🟢 BOM      7.0 │ FormTemplate#none
🟢 BOM      7.0 │ User#completed_forms             app/models/user.rb:38-41
🟢 BOM      6.1 │ ImportService#parse_json_file    app/services/import_service.rb:27-33
🟢 BOM      5.9 │ Student::FormsController#show    app/controllers/student/forms_controller.rb:15-18
🟢 BOM      5.9 │ Admin::FormsController#publish   app/controllers/admin/forms_controller.rb:67-73
🟢 BOM      5.9 │ Admin::FormsController#close     app/controllers/admin/forms_controller.rb:75-81
🟢 BOM      5.8 │ Admin::FormTemplatesController#update app/controllers/admin/form_templates_controller.rb:38-44
🟢 BOM      5.8 │ Admin::UsersController#update    app/controllers/admin/users_controller.rb:19-25
🟢 BOM      5.8 │ ImportService#import_klasses     app/services/import_service.rb:13-23
🟢 BOM      5.2 │ Admin::DashboardController#index app/controllers/admin/dashboard_controller.rb:8-12
🟢 BOM      5.0 │ Admin::FormsController#none
🟢 BOM      5.0 │ Student::FormsController#none
🟢 BOM      5.0 │ FormAnswer#none
🟢 BOM      4.8 │ Admin::FormsController#show      app/controllers/admin/forms_controller.rb:14-17
🟢 BOM      4.8 │ Klass#students                   app/models/klass.rb:18-20
🟢 BOM      4.8 │ Klass#teachers                   app/models/klass.rb:22-24
🟢 BOM      4.7 │ Admin::ImportsController#check_admin app/controllers/admin/imports_controller.rb:48-50
🟢 BOM      4.7 │ Admin::DashboardController#check_admin app/controllers/admin/dashboard_controller.rb:16-18
🟢 BOM      4.7 │ Admin::FormTemplatesController#edit app/controllers/admin/form_templates_controller.rb:34-36
🟢 BOM      4.7 │ Admin::FormTemplatesController#check_admin app/controllers/admin/form_templates_controller.rb:64-66
🟢 BOM      4.7 │ Admin::FormsController#check_admin app/controllers/admin/forms_controller.rb:101-103
🟢 BOM      4.7 │ Admin::UsersController#check_admin app/controllers/admin/users_controller.rb:42-44
🟢 BOM      4.7 │ Student::FormsController#check_student app/controllers/student/forms_controller.rb:60-62
🟢 BOM      4.7 │ Student::FormsController#update_answers app/controllers/student/forms_controller.rb:70-73
🟢 BOM      4.2 │ Admin::FormsController#new       app/controllers/admin/forms_controller.rb:19-23
🟢 BOM      4.0 │ Admin::FormTemplatesController#none
🟢 BOM      4.0 │ Admin::UsersController#none
🟢 BOM      4.0 │ ClassMember#none
🟢 BOM      3.8 │ Admin::ImportsController#index   app/controllers/admin/imports_controller.rb:8-11
🟢 BOM      3.7 │ Admin::FormTemplatesController#index app/controllers/admin/form_templates_controller.rb:9-11
🟢 BOM      3.7 │ Admin::FormTemplatesController#set_form_template app/controllers/admin/form_templates_controller.rb:53-55
🟢 BOM      3.7 │ Admin::FormsController#set_form  app/controllers/admin/forms_controller.rb:89-91
🟢 BOM      3.7 │ Admin::FormsController#set_form_response app/controllers/admin/forms_controller.rb:93-95
🟢 BOM      3.7 │ Admin::UsersController#set_user  app/controllers/admin/users_controller.rb:34-36
🟢 BOM      3.7 │ Student::FormsController#set_form app/controllers/student/forms_controller.rb:56-58
🟢 BOM      3.7 │ ImportService#import_students    app/services/import_service.rb:56-62
🟢 BOM      3.6 │ Admin::FormTemplatesController#form_template_params app/controllers/admin/form_templates_controller.rb:57-62
🟢 BOM      3.6 │ Admin::FormsController#form_params app/controllers/admin/forms_controller.rb:97-99
🟢 BOM      3.6 │ Admin::UsersController#user_params app/controllers/admin/users_controller.rb:38-40
🟢 BOM      3.4 │ Form#completed_responses         app/models/form.rb:23-25
🟢 BOM      3.4 │ Admin::FormTemplatesController#new app/controllers/admin/form_templates_controller.rb:16-19
🟢 BOM      3.2 │ Admin::FormTemplatesController#destroy app/controllers/admin/form_templates_controller.rb:46-49
🟢 BOM      3.2 │ Admin::FormsController#destroy   app/controllers/admin/forms_controller.rb:62-65
🟢 BOM      3.2 │ Admin::UsersController#destroy   app/controllers/admin/users_controller.rb:27-30
🟢 BOM      3.0 │ Admin::DashboardController#none
🟢 BOM      3.0 │ Admin::ImportsController#none
🟢 BOM      3.0 │ ImportService#initialize         app/services/import_service.rb:6-10
🟢 BOM      2.8 │ Admin::FormsController#edit      app/controllers/admin/forms_controller.rb:47-50
🟢 BOM      2.4 │ Admin::FormsController#index     app/controllers/admin/forms_controller.rb:10-12
🟢 BOM      2.2 │ FormResponse#completed?          app/models/form_response.rb:14-16
🟢 BOM      2.2 │ FormResponse#pending?            app/models/form_response.rb:18-20
🟢 BOM      2.2 │ FormResponse#submit!             app/models/form_response.rb:32-34
🟢 BOM      2.2 │ FormTemplateField#requires_options? app/models/form_template_field.rb:22-24
🟢 BOM      2.2 │ User#admin?                      app/models/user.rb:20-22
🟢 BOM      2.2 │ User#user?                       app/models/user.rb:24-26
🟢 BOM      2.0 │ ApplicationMailer#none
🟢 BOM      2.0 │ ImportService#none
🟢 BOM      1.4 │ Admin::UsersController#index     app/controllers/admin/users_controller.rb:9-11
🟢 BOM      1.0 │ ApplicationController#none
🟢 BOM      1.0 │ HomeController#none
🟢 BOM      1.0 │ ApplicationRecord#none

═══════════════════════════════════════════════════════════════════════════════
📊 RESUMO: 🔴 3 alto (>20) │ 🟡 1 médio (>15) │ 🟢 80 bom (≤15)
═══════════════════════════════════════════════════════════════════════════════
```

Como é possível observar, tem 3 métodos que precisam ser refatorados. Aqui está o antes e depois de cada método.

**Admin::ImportsController#import_klasses**

```ruby
# Antes - imports_controller

# app/controllers/admin/imports_controller.rb

module Admin
  class ImportsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def index
      @total_klasses = Klass.count
      @total_users = User.where(role: :user).count
    end

    def import_klasses
      if params[:file].blank?
        redirect_to admin_imports_path, alert: 'Por favor, selecione um arquivo'
        return
      end

      file = params[:file]
      
      # Validar tipo de arquivo
      unless file.content_type == 'application/json' || file.original_filename.end_with?('.json')
        redirect_to admin_imports_path, alert: 'Por favor, envie um arquivo JSON válido'
        return
      end

      # Executar importação
      service = ImportService.new(file.path)
      result = service.import_klasses

      if result[:success]
        message = "✅ #{result[:imported]} turma(s) importada(s) com sucesso!"
        
        if result[:errors].present?
          message += "\n\n⚠️ Aviso: #{result[:errors].count} erro(s) durante importação:"
          result[:errors].each { |error| message += "\n• #{error}" }
          redirect_to admin_imports_path, alert: message
        else
          redirect_to admin_imports_path, notice: message
        end
      else
        redirect_to admin_imports_path, alert: "❌ Erro na importação: #{result[:error]}"
      end
    end

    private

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
```

```ruby
# Depois - imports_controller

# app/controllers/admin/imports_controller.rb

module Admin
  class ImportsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def index
      @total_klasses = Klass.count
      @total_users = User.where(role: :user).count
    end

    def import_klasses
      return redirect_with_error('Por favor, selecione um arquivo') if params[:file].blank?
      return redirect_with_error('Por favor, envie um arquivo JSON válido') unless valid_json_file?

      result = ImportService.new(params[:file].path).import_klasses
      handle_import_result(result)
    end

    private

    def valid_json_file?
      file = params[:file]
      file.content_type == 'application/json' || file.original_filename.end_with?('.json')
    end

    def redirect_with_error(message)
      redirect_to admin_imports_path, alert: message
    end

    def handle_import_result(result)
      if result[:success]
        handle_success(result)
      else
        redirect_with_error("❌ Erro na importação: #{result[:error]}")
      end
    end

    def handle_success(result)
      message = "✅ #{result[:imported]} turma(s) importada(s) com sucesso!"
      
      if result[:errors].present?
        redirect_to admin_imports_path, alert: build_error_message(message, result[:errors])
      else
        redirect_to admin_imports_path, notice: message
      end
    end

    def build_error_message(base_message, errors)
      message = "#{base_message}\n\n⚠️ Aviso: #{errors.count} erro(s) durante importação:"
      errors.each { |error| message += "\n• #{error}" }
      message
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end

```

**Admin::FormsController#create**

```ruby
# Antes - forms_controller

# app/controllers/admin/forms_controller.rb

module Admin
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form, only: [:show, :edit, :update, :destroy, :publish, :close, :view_response]
    before_action :set_form_response, only: [:view_response]

    def index
      @forms = Form.all.order(created_at: :desc)
    end

    def show
      @pending_count = @form.pending_responses.count
      @completed_count = @form.completed_responses.count
    end

    def new
      @form = Form.new
      @form_templates = FormTemplate.all
      @klasses = Klass.all
    end

    def create
      template = FormTemplate.find(form_params[:form_template_id])
      klass = Klass.find(form_params[:klass_id])
      
      @form = Form.new(
        form_template: template,
        klass: klass,
        title: form_params[:title],
        description: form_params[:description],
        due_date: form_params[:due_date],
        status: :draft
      )

      if @form.save
        redirect_to admin_form_path(@form), notice: 'Formulário criado com sucesso!'
      else
        @form_templates = FormTemplate.all
        @klasses = Klass.all
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @form_templates = FormTemplate.all
      @klasses = Klass.all
    end

    def update
      if @form.update(form_params)
        redirect_to admin_form_path(@form), notice: 'Formulário atualizado com sucesso!'
      else
        @form_templates = FormTemplate.all
        @klasses = Klass.all
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @form.destroy
      redirect_to admin_forms_url, notice: 'Formulário deletado com sucesso!'
    end

    def publish
      if @form.update(status: :published)
        redirect_to admin_form_path(@form), notice: 'Formulário publicado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao publicar formulário'
      end
    end

    def close
      if @form.update(status: :closed)
        redirect_to admin_form_path(@form), notice: 'Formulário fechado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao fechar formulário'
      end
    end

    def view_response
      # @form_response já é setado pelo before_action
    end

    private

    def set_form
      @form = Form.find(params[:id])
    end

    def set_form_response
      @form_response = FormResponse.find(params[:response_id])
    end

    def form_params
      params.require(:form).permit(:form_template_id, :klass_id, :title, :description, :due_date, :status)
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end

```

```ruby
# Depois - forms_controller

# app/controllers/admin/forms_controller.rb

module Admin
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form, only: [:show, :edit, :update, :destroy, :publish, :close, :view_response]
    before_action :set_form_response, only: [:view_response]

    def index
      @forms = Form.all.order(created_at: :desc)
    end

    def show
      @pending_count = @form.pending_responses.count
      @completed_count = @form.completed_responses.count
    end

    def new
      @form = Form.new
      load_form_dependencies
    end

    def create
      @form = build_form_from_params

      if @form.save
        redirect_to admin_form_path(@form), notice: 'Formulário criado com sucesso!'
      else
        load_form_dependencies
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      load_form_dependencies
    end

    def update
      if @form.update(form_params)
        redirect_to admin_form_path(@form), notice: 'Formulário atualizado com sucesso!'
      else
        load_form_dependencies
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @form.destroy
      redirect_to admin_forms_url, notice: 'Formulário deletado com sucesso!'
    end

    def publish
      if @form.update(status: :published)
        redirect_to admin_form_path(@form), notice: 'Formulário publicado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao publicar formulário'
      end
    end

    def close
      if @form.update(status: :closed)
        redirect_to admin_form_path(@form), notice: 'Formulário fechado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao fechar formulário'
      end
    end

    def view_response
      # @form_response já é setado pelo before_action
    end

    private

    def build_form_from_params
      Form.new(
        form_template: FormTemplate.find(form_params[:form_template_id]),
        klass: Klass.find(form_params[:klass_id]),
        title: form_params[:title],
        description: form_params[:description],
        due_date: form_params[:due_date],
        status: :draft
      )
    end

    def load_form_dependencies
      @form_templates = FormTemplate.all
      @klasses = Klass.all
    end

    def set_form
      @form = Form.find(params[:id])
    end

    def set_form_response
      @form_response = FormResponse.find(params[:response_id])
    end

    def form_params
      params.require(:form).permit(:form_template_id, :klass_id, :title, :description, :due_date, :status)
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end

```

**ImportService#find_or_create_user**

```ruby
# Antes - import_service.rb

# app/services/import_service.rb

class ImportService
  attr_reader :file_path, :imported_count, :errors

  def initialize(file_path)
    @file_path = file_path
    @imported_count = 0
    @errors = []
  end

  # Importa turmas com seus estudantes
  def import_klasses
    data = parse_json_file

    data.each do |klass_data|
      import_single_klass(klass_data)
    end

    { success: true, imported: @imported_count, errors: @errors }
  rescue StandardError => e
    { success: false, error: e.message, imported: @imported_count, errors: @errors }
  end

  private

  def parse_json_file
    JSON.parse(File.read(@file_path))
  rescue JSON::ParserError => e
    raise "Erro ao ler arquivo JSON: #{e.message}"
  rescue Errno::ENOENT
    raise "Arquivo não encontrado: #{@file_path}"
  end

  def import_single_klass(klass_data)
    klass = find_or_create_klass(klass_data)
    
    # Importar estudantes
    import_students(klass, klass_data['dicente'])
    
    @imported_count += 1
  rescue StandardError => e
    @errors << "Erro ao importar turma #{klass_data['code']}: #{e.message}"
  end

  def find_or_create_klass(klass_data)
    klass_info = klass_data['class']
    
    Klass.find_or_create_by(code: klass_data['code']) do |klass|
      klass.name = klass_data['name']
      klass.semester = klass_info['semester']
      klass.description = "Turma #{klass_info['classCode']} - #{klass_info['time']}"
    end
  end

  def import_students(klass, students_data)
    return unless students_data.present?

    students_data.each do |student_data|
      import_single_student(klass, student_data, 'dicente')
    end
  end

  def import_single_student(klass, student_data, role)
    user = find_or_create_user(student_data)
    
    ClassMember.find_or_create_by(user: user, klass: klass) do |cm|
      cm.role = role
    end
  rescue StandardError => e
    @errors << "Erro ao importar estudante #{student_data['nome']}: #{e.message}"
  end

  def find_or_create_user(user_data)
    user = User.find_by(email: user_data['email'])
    
    if user.present?
      return user
    end

    # Usa matrícula como senha (Opção A)
    password = user_data['matricula']

    user = User.new(
      email: user_data['email'],
      name: user_data['nome'],
      matricula: user_data['matricula'],
      curso: user_data['curso'],
      formacao: user_data['formacao'],
      ocupacao: user_data['ocupacao'],
      password: password,
      password_confirmation: password,
      role: :user
    )

    if user.save
      user
    else
      raise "Erro ao salvar usuário #{user_data['email']}: #{user.errors.full_messages.join(', ')}"
    end
  end
end
```

```ruby
# Depois = import_service.rb

# app/services/import_service.rb

class ImportService
  attr_reader :file_path, :imported_count, :errors

  def initialize(file_path)
    @file_path = file_path
    @imported_count = 0
    @errors = []
  end

  def import_klasses
    data = parse_json_file

    data.each do |klass_data|
      import_single_klass(klass_data)
    end

    { success: true, imported: @imported_count, errors: @errors }
  rescue StandardError => e
    { success: false, error: e.message, imported: @imported_count, errors: @errors }
  end

  private

  def parse_json_file
    JSON.parse(File.read(@file_path))
  rescue JSON::ParserError => e
    raise "Erro ao ler arquivo JSON: #{e.message}"
  rescue Errno::ENOENT
    raise "Arquivo não encontrado: #{@file_path}"
  end

  def import_single_klass(klass_data)
    klass = find_or_create_klass(klass_data)
    import_students(klass, klass_data['dicente'])
    @imported_count += 1
  rescue StandardError => e
    @errors << "Erro ao importar turma #{klass_data['code']}: #{e.message}"
  end

  def find_or_create_klass(klass_data)
    klass_info = klass_data['class']

    Klass.find_or_create_by(code: klass_data['code']) do |klass|
      klass.name = klass_data['name']
      klass.semester = klass_info['semester']
      klass.description = "Turma #{klass_info['classCode']} - #{klass_info['time']}"
    end
  end

  def import_students(klass, students_data)
    return unless students_data.present?

    students_data.each do |student_data|
      import_single_student(klass, student_data, 'dicente')
    end
  end

  def import_single_student(klass, student_data, role)
    user = find_or_create_user(student_data)

    ClassMember.find_or_create_by(user: user, klass: klass) do |cm|
      cm.role = role
    end
  rescue StandardError => e
    @errors << "Erro ao importar estudante #{student_data['nome']}: #{e.message}"
  end

  def find_or_create_user(user_data)
    User.find_by(email: user_data['email']) || create_new_user(user_data)
  end

  def create_new_user(user_data)
    user = build_user(user_data)
    
    if user.save
      user
    else
      raise "Erro ao salvar usuário #{user_data['email']}: #{user.errors.full_messages.join(', ')}"
    end
  end

  def build_user(user_data)
    password = user_data['matricula']
    
    User.new(
      email: user_data['email'],
      name: user_data['nome'],
      matricula: user_data['matricula'],
      curso: user_data['curso'],
      formacao: user_data['formacao'],
      ocupacao: user_data['ocupacao'],
      password: password,
      password_confirmation: password,
      role: :user
    )
  end
end

```

Após realizar as modificações acima e rodar os comandos no flog e rubycritic, obtemos a seguinte saída, que indica que as complexidades foram reduzidas:

```ruby
═══════════════════════════════════════════════════════════════════════════════
                      ANÁLISE ABC SCORE - TODOS OS MÉTODOS
═══════════════════════════════════════════════════════════════════════════════

🟡 MÉDIO   17.2 │ Admin::FormsController#build_form_from_params app/controllers/admin/forms_controller.rb:75-84
🟡 MÉDIO   16.5 │ Student::FormsController#answer  app/controllers/student/forms_controller.rb:20-37
🟢 BOM     15.0 │ Admin::ImportsController#import_klasses app/controllers/admin/imports_controller.rb:13-19
🟢 BOM     14.8 │ Admin::FormTemplatesHelper#link_to_add_fields app/helpers/admin/form_templates_helper.rb:4-14
🟢 BOM     14.4 │ Student::FormsController#submit_answer app/controllers/student/forms_controller.rb:39-52
🟢 BOM     13.5 │ FormResponse#build_answers_for_fields app/models/form_response.rb:23-29
🟢 BOM     13.3 │ HomeController#index             app/controllers/home_controller.rb:6-13
🟢 BOM     13.0 │ User#pending_forms               app/models/user.rb:29-35
🟢 BOM     10.9 │ Admin::ImportsController#handle_success app/controllers/admin/imports_controller.rb:40-48
🟢 BOM      9.8 │ ImportService#import_single_klass app/services/import_service.rb:34-40
🟢 BOM      9.6 │ Form#none
🟢 BOM      9.4 │ Admin::FormTemplatesController#create app/controllers/admin/form_templates_controller.rb:21-29
🟢 BOM      9.3 │ ImportService#find_or_create_klass app/services/import_service.rb:42-50
🟢 BOM      9.3 │ ImportService#build_user         app/services/import_service.rb:84-98
🟢 BOM      9.0 │ ImportService#create_new_user    app/services/import_service.rb:74-82
🟢 BOM      9.0 │ FormTemplateField#none
🟢 BOM      8.9 │ Student::FormsController#check_form_accessible app/controllers/student/forms_controller.rb:64-68
🟢 BOM      8.4 │ Klass#none
🟢 BOM      8.3 │ User#none
🟢 BOM      7.6 │ Form#pending_responses           app/models/form.rb:18-20
🟢 BOM      7.6 │ FormTemplateField#ensure_position_is_integer app/models/form_template_field.rb:26-28
🟢 BOM      7.5 │ Student::FormsController#index   app/controllers/student/forms_controller.rb:10-13
🟢 BOM      7.4 │ ImportService#import_single_student app/services/import_service.rb:60-68
🟢 BOM      7.1 │ Admin::ImportsController#valid_json_file? app/controllers/admin/imports_controller.rb:23-26
🟢 BOM      7.1 │ Admin::FormsController#update    app/controllers/admin/forms_controller.rb:39-46
🟢 BOM      7.0 │ FormResponse#none
🟢 BOM      7.0 │ FormTemplate#none
🟢 BOM      7.0 │ User#completed_forms             app/models/user.rb:38-41
🟢 BOM      6.9 │ Admin::FormsController#create    app/controllers/admin/forms_controller.rb:24-33
🟢 BOM      6.1 │ ImportService#parse_json_file    app/services/import_service.rb:26-32
🟢 BOM      5.9 │ Student::FormsController#show    app/controllers/student/forms_controller.rb:15-18
🟢 BOM      5.9 │ Admin::FormsController#publish   app/controllers/admin/forms_controller.rb:53-59
🟢 BOM      5.9 │ Admin::FormsController#close     app/controllers/admin/forms_controller.rb:61-67
🟢 BOM      5.8 │ Admin::FormTemplatesController#update app/controllers/admin/form_templates_controller.rb:35-41
🟢 BOM      5.8 │ Admin::UsersController#update    app/controllers/admin/users_controller.rb:19-25
🟢 BOM      5.8 │ ImportService#import_klasses     app/services/import_service.rb:12-22
🟢 BOM      5.2 │ Admin::DashboardController#index app/controllers/admin/dashboard_controller.rb:8-12
🟢 BOM      5.0 │ Admin::FormsController#none
🟢 BOM      5.0 │ Student::FormsController#none
🟢 BOM      5.0 │ FormAnswer#none
🟢 BOM      4.8 │ Admin::FormsController#show      app/controllers/admin/forms_controller.rb:14-17
🟢 BOM      4.8 │ Klass#students                   app/models/klass.rb:18-20
🟢 BOM      4.8 │ Klass#teachers                   app/models/klass.rb:22-24
🟢 BOM      4.7 │ Admin::DashboardController#check_admin app/controllers/admin/dashboard_controller.rb:16-18
🟢 BOM      4.7 │ Admin::FormTemplatesController#edit app/controllers/admin/form_templates_controller.rb:31-33
🟢 BOM      4.7 │ Admin::FormTemplatesController#check_admin app/controllers/admin/form_templates_controller.rb:61-63
🟢 BOM      4.7 │ Admin::FormsController#check_admin app/controllers/admin/forms_controller.rb:103-105
🟢 BOM      4.7 │ Admin::ImportsController#check_admin app/controllers/admin/imports_controller.rb:56-58
🟢 BOM      4.7 │ Admin::UsersController#check_admin app/controllers/admin/users_controller.rb:42-44
🟢 BOM      4.7 │ Student::FormsController#check_student app/controllers/student/forms_controller.rb:60-62
🟢 BOM      4.7 │ Student::FormsController#update_answers app/controllers/student/forms_controller.rb:70-73
🟢 BOM      4.6 │ Admin::ImportsController#handle_import_result app/controllers/admin/imports_controller.rb:32-38
🟢 BOM      4.0 │ Admin::FormTemplatesController#none
🟢 BOM      4.0 │ Admin::UsersController#none
🟢 BOM      4.0 │ ClassMember#none
🟢 BOM      3.9 │ Admin::ImportsController#build_error_message app/controllers/admin/imports_controller.rb:50-54
🟢 BOM      3.8 │ Admin::ImportsController#index   app/controllers/admin/imports_controller.rb:8-11
🟢 BOM      3.7 │ Admin::FormTemplatesController#index app/controllers/admin/form_templates_controller.rb:9-11
🟢 BOM      3.7 │ Admin::FormTemplatesController#set_form_template app/controllers/admin/form_templates_controller.rb:50-52
🟢 BOM      3.7 │ Admin::FormsController#set_form  app/controllers/admin/forms_controller.rb:91-93
🟢 BOM      3.7 │ Admin::FormsController#set_form_response app/controllers/admin/forms_controller.rb:95-97
🟢 BOM      3.7 │ Admin::UsersController#set_user  app/controllers/admin/users_controller.rb:34-36
🟢 BOM      3.7 │ Student::FormsController#set_form app/controllers/student/forms_controller.rb:56-58
🟢 BOM      3.7 │ ImportService#import_students    app/services/import_service.rb:52-58
🟢 BOM      3.6 │ ImportService#find_or_create_user app/services/import_service.rb:70-72
🟢 BOM      3.6 │ Admin::FormTemplatesController#form_template_params app/controllers/admin/form_templates_controller.rb:54-59
🟢 BOM      3.6 │ Admin::FormsController#form_params app/controllers/admin/forms_controller.rb:99-101
🟢 BOM      3.6 │ Admin::UsersController#user_params app/controllers/admin/users_controller.rb:38-40
🟢 BOM      3.4 │ Form#completed_responses         app/models/form.rb:23-25
🟢 BOM      3.4 │ Admin::FormTemplatesController#new app/controllers/admin/form_templates_controller.rb:16-19
🟢 BOM      3.2 │ Admin::FormTemplatesController#destroy app/controllers/admin/form_templates_controller.rb:43-46
🟢 BOM      3.2 │ Admin::FormsController#destroy   app/controllers/admin/forms_controller.rb:48-51
🟢 BOM      3.2 │ Admin::UsersController#destroy   app/controllers/admin/users_controller.rb:27-30
🟢 BOM      3.0 │ Admin::DashboardController#none
🟢 BOM      3.0 │ Admin::ImportsController#none
🟢 BOM      3.0 │ ImportService#initialize         app/services/import_service.rb:6-10
🟢 BOM      2.8 │ Admin::FormsController#load_form_dependencies app/controllers/admin/forms_controller.rb:86-89
🟢 BOM      2.4 │ Admin::FormsController#index     app/controllers/admin/forms_controller.rb:10-12
🟢 BOM      2.2 │ Admin::FormsController#new       app/controllers/admin/forms_controller.rb:19-22
🟢 BOM      2.2 │ Admin::ImportsController#redirect_with_error app/controllers/admin/imports_controller.rb:28-30
🟢 BOM      2.2 │ FormResponse#completed?          app/models/form_response.rb:14-16
🟢 BOM      2.2 │ FormResponse#pending?            app/models/form_response.rb:18-20
🟢 BOM      2.2 │ FormResponse#submit!             app/models/form_response.rb:32-34
🟢 BOM      2.2 │ FormTemplateField#requires_options? app/models/form_template_field.rb:22-24
🟢 BOM      2.2 │ User#admin?                      app/models/user.rb:20-22
🟢 BOM      2.2 │ User#user?                       app/models/user.rb:24-26
🟢 BOM      2.0 │ ApplicationMailer#none
🟢 BOM      2.0 │ ImportService#none
🟢 BOM      1.4 │ Admin::UsersController#index     app/controllers/admin/users_controller.rb:9-11
🟢 BOM      1.0 │ Admin::FormsController#edit      app/controllers/admin/forms_controller.rb:35-37
🟢 BOM      1.0 │ ApplicationController#none
🟢 BOM      1.0 │ HomeController#none
🟢 BOM      1.0 │ ApplicationRecord#none

═══════════════════════════════════════════════════════════════════════════════
📊 RESUMO: 🔴 0 alto (>20) │ 🟡 2 médio (>15) │ 🟢 91 bom (≤15)
═══════════════════════════════════════════════════════════════════════════════
```

Caso deseje, basta abrir o arquivo overview.html na pasta do rubycritic (dentro de tmp) e analisar os resultados.

---

## 2. Garantindo cobertura de testes > 90%:

Após realizar a instalação e configuração do simplecov e executar o comando `bundle exec rspec` é possível obter a cobertura total dos testes do nosso código:

```ruby
bgrod@Bernardo:~/sprint3/CAMAAR-Grupo-10$ bundle exec rspec

Randomized with seed 41365
..............**...................................................................................................................................................*................***............................................*.......**.............................................................*

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) users/show.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/admin/users/show.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/admin/users/show.html.erb_spec.rb:4

  2) Admin::DashboardHelper add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/helpers/admin/dashboard_helper_spec.rb
     # Not yet implemented
     # ./spec/helpers/admin/dashboard_helper_spec.rb:14

  3) users/index.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/admin/users/index.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/admin/users/index.html.erb_spec.rb:4

  4) users/edit.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/admin/users/edit.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/admin/users/edit.html.erb_spec.rb:4

  5) users/update.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/admin/users/update.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/admin/users/update.html.erb_spec.rb:4

  6) dashboard/index.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/admin/dashboard/index.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/admin/dashboard/index.html.erb_spec.rb:4

  7) Admin::UsersHelper add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/helpers/admin/users_helper_spec.rb
     # Not yet implemented
     # ./spec/helpers/admin/users_helper_spec.rb:14

  8) users/destroy.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/admin/users/destroy.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/admin/users/destroy.html.erb_spec.rb:4

  9) HomeHelper add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/helpers/home_helper_spec.rb
     # Not yet implemented
     # ./spec/helpers/home_helper_spec.rb:14

  10) home/index.html.erb add some examples to (or delete) /home/bgrod/sprint3/CAMAAR-Grupo-10/spec/views/home/index.html.erb_spec.rb
     # Not yet implemented
     # ./spec/views/home/index.html.erb_spec.rb:4

Top 10 slowest examples (2.52 seconds, 51.7% of total time):
  Admin::Forms POST /admin/forms (create) com parâmetros inválidos não cria um formulário sem template
    0.30314 seconds ./spec/requests/admin/forms_spec.rb:163
  Student::Forms GET /student/forms/:id (show) retorna 404 para formulário inexistente
    0.29641 seconds ./spec/requests/student/forms_spec.rb:87
  Admin::Forms GET /admin/forms/:id/view_response retorna 404 para resposta inexistente
    0.27824 seconds ./spec/requests/admin/forms_spec.rb:360
  Admin::Users GET /admin/users/:id (show) retorna 404 para usuário inexistente
    0.26641 seconds ./spec/requests/admin/users_spec.rb:66
  Admin::Forms GET /admin/forms/:id (show) retorna 404 para formulário inexistente
    0.26154 seconds ./spec/requests/admin/forms_spec.rb:94
  Admin::FormTemplates DELETE /admin/form_templates/:id (destroy) redireciona com 404 para template inexistente
    0.25699 seconds ./spec/requests/admin/form_templates_spec.rb:367
  Admin::FormTemplates GET /admin/form_templates/:id/edit redireciona com 404 para template inexistente
    0.25622 seconds ./spec/requests/admin/form_templates_spec.rb:237
  Admin::FormTemplates GET /admin/form_templates/:id (show) retorna 404 para template inexistente
    0.25605 seconds ./spec/requests/admin/form_templates_spec.rb:95
  FormAnswer#create não cria answer sem resposta
    0.24659 seconds ./spec/models/form_answer_spec.rb:50
  Admin::Dashboards GET admin dashboard returns http success
    0.09424 seconds ./spec/requests/admin/dashboard_spec.rb:13

Top 10 slowest example groups:
  Admin::Dashboards
    0.09441 seconds average (0.09441 seconds / 1 example) ./spec/requests/admin/dashboard_spec.rb:3
  Admin::Forms
    0.03612 seconds average (1.26 seconds / 35 examples) ./spec/requests/admin/forms_spec.rb:5
  Student::Forms
    0.03049 seconds average (0.57935 seconds / 19 examples) ./spec/requests/student/forms_spec.rb:3
  Admin::FormTemplates
    0.02982 seconds average (0.98415 seconds / 33 examples) ./spec/requests/admin/form_templates_spec.rb:5
  FormAnswer
    0.02464 seconds average (0.34501 seconds / 14 examples) ./spec/models/form_answer_spec.rb:5
  Admin::Users
    0.02451 seconds average (0.44119 seconds / 18 examples) ./spec/requests/admin/users_spec.rb:3
  Homes
    0.01233 seconds average (0.19728 seconds / 16 examples) ./spec/requests/home_spec.rb:3
  Admin::Imports
    0.00922 seconds average (0.23047 seconds / 25 examples) ./spec/requests/admin/imports_spec.rb:3
  FormResponse
    0.00854 seconds average (0.17934 seconds / 21 examples) ./spec/models/form_response_spec.rb:5
  Form
    0.00727 seconds average (0.16732 seconds / 23 examples) ./spec/models/form_spec.rb:5

Finished in 4.87 seconds (files took 2.14 seconds to load)
299 examples, 0 failures, 10 pending

Randomized with seed 41365

Coverage report generated for RSpec to /home/bgrod/sprint3/CAMAAR-Grupo-10/coverage.
Line Coverage: 98.58% (347 / 352)

COVERAGE:  98.58% -- 347/352 lines in 22 files

+----------+-------------------------------------------+-------+--------+---------------+
| coverage | file                                      | lines | missed | missing       |
+----------+-------------------------------------------+-------+--------+---------------+
|  92.45%  | app/controllers/admin/forms_controller.rb | 53    | 4      | 30-31, 57, 65 |
|  97.87%  | app/services/import_service.rb            | 47    | 1      | 39            |
+----------+-------------------------------------------+-------+--------+---------------+
20 file(s) with 100% coverage not shown
```

Como é possível observar, todos os testes estão passando e a cobertura total é de 98.58%, com todos os controllers, models e services atingindo cobertura maior que 90%.
OBS: Alguns testes não estão implementados como visto no resultado (indicados com *), mas eles não influenciam ou indicam mal funcionamento da plataforma.

---

## 3. Happy Paths e Sad Paths no Cucumber

Após verificar a instalação e funcionamento do Cucumber em nosso sistema, desenvolvemos os arquivos de step.rb para realizar a execução dos happy path e sad path descritos nas features:

```ruby
├── step_definitions
│   ├── admin_response_steps.rb
│   ├── authentication_steps.rb
│   ├── form_field_steps.rb
│   ├── form_steps.rb
│   ├── import_steps.rb
│   ├── navigation_steps.rb
│   ├── student_form_steps.rb
│   ├── template_steps.rb
│   └── user_steps.rb
```

E após a implementação desses arquivos e a execução do comando `bundle exec cucumber` obtemos a saída, indicando sucesso na implementação:

```ruby
bgrod@Bernardo:~/sprint3/CAMAAR-Grupo-10$ bundle exec cucumber
Using the default profile...
# language: pt
Funcionalidade: Criar e Gerenciar Templates de Formulários
  Como administrador
  Eu quero criar templates de formulários reutilizáveis
  Para usar como base na criação de múltiplos formulários

  Contexto:                                   # features/criar_gerenciar_templates.feature:7
    Dado que sou um usuário admin autenticado # features/step_definitions/template_steps.rb:5

  # HAPPY PATH
  Cenário: Listar todos os templates criados        # features/criar_gerenciar_templates.feature:11
    Dado que existem 3 templates criados pelo admin # features/step_definitions/template_steps.rb:40
    Quando acesso a página de templates             # features/step_definitions/template_steps.rb:65
    Então devo ver todos os 3 templates listados    # features/step_definitions/template_steps.rb:129

  Cenário: Deletar template com sucesso                   # features/criar_gerenciar_templates.feature:16
    Dado que existe um template chamado "Pesquisa Antiga" # features/step_definitions/template_steps.rb:25
    Quando acesso a página de templates                   # features/step_definitions/template_steps.rb:65
    E clico no botão "Deletar"                            # features/step_definitions/authentication_steps.rb:23
    Então o template não deve estar mais listado          # features/step_definitions/template_steps.rb:124

  # SAD PATH
  Cenário: Falha ao criar template sem nome       # features/criar_gerenciar_templates.feature:23
    Quando acesso a página de criação de template # features/step_definitions/template_steps.rb:69
    E deixo o nome vazio                          # features/step_definitions/template_steps.rb:92
    E preencho a descrição com "Uma descrição"    # features/step_definitions/template_steps.rb:88
    E clico no botão "Criar Template"             # features/step_definitions/authentication_steps.rb:23
    Então o template não deve ser criado          # features/step_definitions/template_steps.rb:135

  Cenário: Falha ao criar template sem descrição  # features/criar_gerenciar_templates.feature:30
    Quando acesso a página de criação de template # features/step_definitions/template_steps.rb:69
    E preencho o nome com "Template Incompleto"   # features/step_definitions/template_steps.rb:83
    E deixo a descrição vazia                     # features/step_definitions/template_steps.rb:96
    E clico no botão "Criar Template"             # features/step_definitions/authentication_steps.rb:23
    Então o template não deve ser criado          # features/step_definitions/template_steps.rb:135

  Cenário: Usuário não-admin não consegue criar template                             # features/criar_gerenciar_templates.feature:37
    Dado que sou um usuário dicente autenticado                                      # features/step_definitions/template_steps.rb:15
    Quando tento acessar a página de criação de template (/admin/form_templates/new) # features/step_definitions/template_steps.rb:77
    Então devo ser redirecionado para a página inicial                               # features/step_definitions/template_steps.rb:140

# language: pt
Funcionalidade: Criar e Publicar Formulários
  Como administrador
  Eu quero criar formulários baseados em templates
  E publicar para que alunos de uma turma possam responder

  Contexto:                                                             # features/criar_publicar_formularios.feature:7
    Dado que sou um usuário admin autenticado                           # features/step_definitions/template_steps.rb:5
    E existe um template de formulário chamado "Pesquisa de Satisfação" # features/step_definitions/form_steps.rb:5
    E existe uma turma "CC001" com 3 alunos registrados                 # features/step_definitions/form_steps.rb:20

  Cenário: Criar formulário com sucesso                                         # features/criar_publicar_formularios.feature:13
    Quando acesso a página de formulários (/admin/forms)                        # features/step_definitions/form_steps.rb:95
    E clico no link "Novo Formulário"                                           # features/step_definitions/authentication_steps.rb:27
    E seleciono o template "Pesquisa de Satisfação"                             # features/step_definitions/form_steps.rb:117
    E seleciono a turma "CC001"                                                 # features/step_definitions/form_steps.rb:121
    E preencho o título com "Pesquisa - Algoritmos - 2025.1"                    # features/step_definitions/form_steps.rb:125
    E preencho a descrição com "Sua opinião é importante para melhorar o curso" # features/step_definitions/template_steps.rb:88
    E clico no botão "Criar Formulário"                                         # features/step_definitions/authentication_steps.rb:23
    Então o formulário deve estar com status "Rascunho"                         # features/step_definitions/form_steps.rb:146
    E o formulário deve estar listado na página de formulários                  # features/step_definitions/form_steps.rb:150

  Cenário: Publicar formulário com sucesso             # features/criar_publicar_formularios.feature:24
    Dado que existe um formulário em status "Rascunho" # features/step_definitions/form_steps.rb:31
    Quando acesso a página de formulários              # features/step_definitions/form_steps.rb:99
    E clico no botão "Publicar"                        # features/step_definitions/authentication_steps.rb:23
    Então o formulário deve ter status "Publicado"     # features/step_definitions/form_steps.rb:155

  Cenário: Fechar formulário com sucesso                # features/criar_publicar_formularios.feature:30
    Dado que existe um formulário em status "Publicado" # features/step_definitions/form_steps.rb:31
    Quando acesso o formulário na página show           # features/step_definitions/form_steps.rb:107
    E clico no botão "Fechar"                           # features/step_definitions/authentication_steps.rb:23
    Então o formulário deve ter status "Fechado"        # features/step_definitions/form_steps.rb:155

  Cenário: Editar formulário em rascunho                                        # features/criar_publicar_formularios.feature:36
    Dado que existe um formulário em status "Rascunho" com título "Pesquisa v1" # features/step_definitions/form_steps.rb:52
    Quando acesso o formulário na página show                                   # features/step_definitions/form_steps.rb:107
    E clico no link "Editar"                                                    # features/step_definitions/authentication_steps.rb:27
    E altero o título para "Pesquisa v2"                                        # features/step_definitions/form_steps.rb:139
    E clico no botão "Atualizar Formulário"                                     # features/step_definitions/authentication_steps.rb:23
    Então o formulário deve ter o novo título "Pesquisa v2"                     # features/step_definitions/form_steps.rb:169

  Cenário: Listar todos os formulários             # features/criar_publicar_formularios.feature:44
    Dado que existem 3 formulários criados         # features/step_definitions/form_steps.rb:74
    Quando acesso a página de formulários          # features/step_definitions/form_steps.rb:99
    Então devo ver todos os 3 formulários listados # features/step_definitions/form_steps.rb:159

  Cenário: Falha ao criar formulário sem título     # features/criar_publicar_formularios.feature:50
    Quando acesso a página de criação de formulário # features/step_definitions/form_steps.rb:103
    E seleciono o template "Pesquisa de Satisfação" # features/step_definitions/form_steps.rb:117
    E seleciono a turma "CC001"                     # features/step_definitions/form_steps.rb:121
    E deixo o título vazio                          # features/step_definitions/form_steps.rb:135
    E preencho a descrição com "Uma descrição"      # features/step_definitions/template_steps.rb:88
    E clico no botão "Criar Formulário"             # features/step_definitions/authentication_steps.rb:23
    Então o formulário não deve ser criado          # features/step_definitions/form_steps.rb:165

  Cenário: Falha ao editar formulário já publicado      # features/criar_publicar_formularios.feature:59
    Dado que existe um formulário em status "Publicado" # features/step_definitions/form_steps.rb:31
    Quando acesso o formulário na página show           # features/step_definitions/form_steps.rb:107
    Então não devo ver o botão "Editar"                 # features/step_definitions/form_steps.rb:173

  Cenário: Usuário não-admin não consegue criar formulário                    # features/criar_publicar_formularios.feature:64
    Dado que sou um usuário dicente autenticado                               # features/step_definitions/template_steps.rb:15
    Quando tento acessar a página de criação de formulário (/admin/forms/new) # features/step_definitions/form_steps.rb:111
    Então devo ser redirecionado para a página inicial                        # features/step_definitions/template_steps.rb:140

# language: pt
Funcionalidade: Importar Turmas e Alunos via JSON
  Como administrador
  Eu quero importar turmas e alunos de um arquivo JSON
  Para registrar os dados dos estudantes no sistema de forma automatizada

  Contexto:                                   # features/importar_turmas_alunos.feature:7
    Dado que sou um usuário admin autenticado # features/step_definitions/template_steps.rb:5

  Cenário: Acessar página de importação                   # features/importar_turmas_alunos.feature:11
    Quando acesso a página de importação (/admin/imports) # features/step_definitions/import_steps.rb:33
    Então devo ver o formulário de upload de arquivo      # features/step_definitions/import_steps.rb:47
    E devo ver as instruções de importação                # features/step_definitions/import_steps.rb:52

  Cenário: Visualizar estatísticas da importação # features/importar_turmas_alunos.feature:16
    Dado que existem 3 turmas importadas         # features/step_definitions/import_steps.rb:5
    E existem 10 alunos registrados              # features/step_definitions/import_steps.rb:18
    Quando acesso a página de importação         # features/step_definitions/import_steps.rb:37
    Então devo ver "3" turmas no total           # features/step_definitions/import_steps.rb:57
    E devo ver "10" alunos no total              # features/step_definitions/import_steps.rb:63

  Cenário: Usuário não-admin não consegue acessar importação     # features/importar_turmas_alunos.feature:24
    Dado que sou um usuário dicente autenticado                  # features/step_definitions/template_steps.rb:15
    Quando tento acessar a página de importação (/admin/imports) # features/step_definitions/import_steps.rb:41
    Então devo ser redirecionado para a página inicial           # features/step_definitions/template_steps.rb:140

# language: pt
Funcionalidade: Login no Sistema CAMAAR
  Como usuário do sistema (admin ou dicente)
  Eu quero fazer login com minhas credenciais
  Para acessar o sistema e suas funcionalidades

  Contexto:                              # features/login_sistema.feature:7
    Dado que o banco de dados está limpo # features/step_definitions/user_steps.rb:2
    E um usuário admin existe com:       # features/step_definitions/user_steps.rb:8
      | email | admin@example.com |
      | senha | senha123          |
      | nome  | Admin             |
    E um usuário dicente existe com:     # features/step_definitions/user_steps.rb:8
      | email     | dicente@example.com |
      | nome      | João Silva          |
      | matricula | 202201234           |

  Cenário: Admin faz login com sucesso                    # features/login_sistema.feature:19
    Quando acesso a página de login                       # features/step_definitions/authentication_steps.rb:3
    E preencho o email com "admin@example.com"            # features/step_definitions/authentication_steps.rb:7
    E preencho a senha com "senha123"                     # features/step_definitions/authentication_steps.rb:11
    E clico no botão "Log in"                             # features/step_definitions/authentication_steps.rb:23
    Então devo estar autenticado como "admin@example.com" # features/step_definitions/authentication_steps.rb:32
    E devo ser redirecionado para o dashboard admin       # features/step_definitions/navigation_steps.rb:1
    E devo ver a mensagem "Bem-vindo, Admin"              # features/step_definitions/authentication_steps.rb:40

  Cenário: Dicente faz login com sucesso                    # features/login_sistema.feature:28
    Quando acesso a página de login                         # features/step_definitions/authentication_steps.rb:3
    E preencho o email com "dicente@example.com"            # features/step_definitions/authentication_steps.rb:7
    E preencho a senha com "202201234"                      # features/step_definitions/authentication_steps.rb:11
    E clico no botão "Log in"                               # features/step_definitions/authentication_steps.rb:23
    Então devo estar autenticado como "dicente@example.com" # features/step_definitions/authentication_steps.rb:32
    E devo ser redirecionado para o dashboard estudante     # features/step_definitions/navigation_steps.rb:7
    E devo ver meus formulários pendentes                   # features/step_definitions/navigation_steps.rb:17

  Cenário: Login falha com email inexistente                      # features/login_sistema.feature:38
    Quando acesso a página de login                               # features/step_definitions/authentication_steps.rb:3
    E preencho o email com "inexistente@example.com"              # features/step_definitions/authentication_steps.rb:7
    E preencho a senha com "qualquersenha"                        # features/step_definitions/authentication_steps.rb:11
/home/bgrod/.local/share/mise/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/devise-4.9.4/lib/devise/failure_app.rb:80: warning: Status code :unprocessable_entity is deprecated and will be removed in a future version of Rack. Please use :unprocessable_content instead.
    E clico no botão "Log in"                                     # features/step_definitions/authentication_steps.rb:23
    Então devo ver a mensagem de erro "E-mail ou senha inválidos" # features/step_definitions/authentication_steps.rb:52
    E não devo estar autenticado                                  # features/step_definitions/authentication_steps.rb:36
    E devo permanecer na página de login                          # features/step_definitions/navigation_steps.rb:13

  Cenário: Login falha com senha incorreta                        # features/login_sistema.feature:47
    Quando acesso a página de login                               # features/step_definitions/authentication_steps.rb:3
    E preencho o email com "dicente@example.com"                  # features/step_definitions/authentication_steps.rb:7
    E preencho a senha com "senhaerrada"                          # features/step_definitions/authentication_steps.rb:11
/home/bgrod/.local/share/mise/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/devise-4.9.4/lib/devise/failure_app.rb:80: warning: Status code :unprocessable_entity is deprecated and will be removed in a future version of Rack. Please use :unprocessable_content instead.
    E clico no botão "Log in"                                     # features/step_definitions/authentication_steps.rb:23
    Então devo ver a mensagem de erro "E-mail ou senha inválidos" # features/step_definitions/authentication_steps.rb:52
    E não devo estar autenticado                                  # features/step_definitions/authentication_steps.rb:36
    E devo permanecer na página de login                          # features/step_definitions/navigation_steps.rb:13

  Cenário: Login falha com campos vazios     # features/login_sistema.feature:56
    Quando acesso a página de login          # features/step_definitions/authentication_steps.rb:3
    E deixo o email vazio                    # features/step_definitions/authentication_steps.rb:15
    E deixo a senha vazia                    # features/step_definitions/authentication_steps.rb:19
/home/bgrod/.local/share/mise/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/devise-4.9.4/lib/devise/failure_app.rb:80: warning: Status code :unprocessable_entity is deprecated and will be removed in a future version of Rack. Please use :unprocessable_content instead.
    E clico no botão "Log in"                # features/step_definitions/authentication_steps.rb:23
    Então devo ver uma mensagem de validação # features/step_definitions/authentication_steps.rb:59
    E não devo estar autenticado             # features/step_definitions/authentication_steps.rb:36

# language: pt
Funcionalidade: Responder Formulários como Aluno
  Como aluno (dicente)
  Eu quero responder formulários publicados da minha turma
  Para participar das pesquisas e avaliações

  Contexto:                                     # features/responder_formularios_aluno.feature:7
    Dado que sou um usuário dicente autenticado # features/step_definitions/template_steps.rb:15
    E estou inscrito na turma "CC001"           # features/step_definitions/student_form_steps.rb:5

  Cenário: Visualizar formulários pendentes                                           # features/responder_formularios_aluno.feature:12
    Dado que existe um formulário publicado "Pesquisa de Satisfação" para minha turma # features/step_definitions/student_form_steps.rb:11
    Quando acesso meu dashboard de formulários                                        # features/step_definitions/student_form_steps.rb:153
    Então devo ver a seção "Formulários Pendentes"                                    # features/step_definitions/student_form_steps.rb:169
    E devo ver o formulário "Pesquisa de Satisfação" na lista                         # features/step_definitions/student_form_steps.rb:173

  Cenário: Acessar página de responder formulário                                     # features/responder_formularios_aluno.feature:18
    Dado que existe um formulário publicado "Pesquisa de Satisfação" para minha turma # features/step_definitions/student_form_steps.rb:11
    Quando acesso meu dashboard de formulários                                        # features/step_definitions/student_form_steps.rb:153
    E clico no link "Responder Formulário"                                            # features/step_definitions/authentication_steps.rb:27
    Então devo ver a página de resposta do formulário                                 # features/step_definitions/student_form_steps.rb:177

  Cenário: Formulários pendentes e respondidos aparecem separados # features/responder_formularios_aluno.feature:24
    Dado que já respondi 2 formulários                            # features/step_definitions/student_form_steps.rb:40
    E existem 3 formulários publicados na minha turma             # features/step_definitions/student_form_steps.rb:64
    Quando acesso meu dashboard de formulários                    # features/step_definitions/student_form_steps.rb:153
    Então devo ver a seção "Formulários Pendentes"                # features/step_definitions/student_form_steps.rb:169
    E devo ver a seção "Formulários Respondidos"                  # features/step_definitions/student_form_steps.rb:169
    E a seção de respondidos deve ter 2 formulários               # features/step_definitions/student_form_steps.rb:186

  Cenário: Visualizar formulário já respondido              # features/responder_formularios_aluno.feature:32
    Dado que existe um formulário publicado que já respondi # features/step_definitions/student_form_steps.rb:83
    Quando acesso meu dashboard de formulários              # features/step_definitions/student_form_steps.rb:153
    E clico em "Ver" na seção de respondidos                # features/step_definitions/student_form_steps.rb:157
    Então devo ver "Formulário respondido"                  # features/step_definitions/student_form_steps.rb:194
    E devo ver minhas respostas anteriores                  # features/step_definitions/student_form_steps.rb:198

  Cenário: Aluno não consegue acessar formulário de outra turma  # features/responder_formularios_aluno.feature:40
    Dado que existe um formulário publicado para a turma "CC002" # features/step_definitions/student_form_steps.rb:114
    E não estou inscrito na turma "CC002"                        # features/step_definitions/student_form_steps.rb:129
    Quando tento acessar esse formulário diretamente             # features/step_definitions/student_form_steps.rb:163
    Então devo ser redirecionado para a página inicial           # features/step_definitions/template_steps.rb:140

  Cenário: Formulário em rascunho não aparece para aluno              # features/responder_formularios_aluno.feature:46
    Dado que existe um formulário em status "Rascunho" da minha turma # features/step_definitions/student_form_steps.rb:133
    Quando acesso meu dashboard de formulários                        # features/step_definitions/student_form_steps.rb:153
    Então o formulário não deve aparecer na lista de pendentes        # features/step_definitions/student_form_steps.rb:203

  Cenário: Formulário fechado não aparece para aluno                 # features/responder_formularios_aluno.feature:51
    Dado que existe um formulário em status "Fechado" da minha turma # features/step_definitions/student_form_steps.rb:133
    Quando acesso meu dashboard de formulários                       # features/step_definitions/student_form_steps.rb:153
    Então o formulário não deve aparecer na lista de pendentes       # features/step_definitions/student_form_steps.rb:203

# language: pt
Funcionalidade: Visualizar Respostas de Formulários (Admin)
  Como administrador
  Eu quero visualizar todas as respostas dos alunos
  Para analisar os resultados dos formulários

  Contexto:                                   # features/visualizar_respostas_admin.feature:7
    Dado que sou um usuário admin autenticado # features/step_definitions/template_steps.rb:5

  Cenário: Visualizar lista de respostas de um formulário            # features/visualizar_respostas_admin.feature:11
    Dado que existe um formulário publicado "Pesquisa de Satisfação" # features/step_definitions/admin_response_steps.rb:5
    E 3 alunos responderam o formulário                              # features/step_definitions/admin_response_steps.rb:36
    Quando acesso a página do formulário                             # features/step_definitions/admin_response_steps.rb:175
    Então devo ver a seção "Respostas"                               # features/step_definitions/student_form_steps.rb:169
    E devo ver 3 respostas na tabela                                 # features/step_definitions/admin_response_steps.rb:195
    E cada resposta deve ter o nome do aluno                         # features/step_definitions/admin_response_steps.rb:199
    E cada resposta deve mostrar o status "Respondido"               # features/step_definitions/admin_response_steps.rb:205

  Cenário: Visualizar detalhes de uma resposta específica # features/visualizar_respostas_admin.feature:20
    Dado que existe um formulário publicado com respostas # features/step_definitions/admin_response_steps.rb:66
    E um aluno "João Silva" respondeu o formulário        # features/step_definitions/admin_response_steps.rb:70
    Quando acesso a página do formulário                  # features/step_definitions/admin_response_steps.rb:175
    E clico em "Ver Respostas" na linha do aluno          # features/step_definitions/admin_response_steps.rb:179
    Então devo ver o nome "João Silva"                    # features/step_definitions/admin_response_steps.rb:211
    E devo ver a data de submissão                        # features/step_definitions/admin_response_steps.rb:215
    E devo ver todas as perguntas e respostas dele        # features/step_definitions/admin_response_steps.rb:219

  Cenário: Visualizar formulário sem respostas               # features/visualizar_respostas_admin.feature:29
    Dado que existe um formulário publicado sem respostas    # features/step_definitions/admin_response_steps.rb:98
    Quando acesso a página do formulário                     # features/step_definitions/admin_response_steps.rb:175
    Então devo ver a mensagem "Nenhum aluno respondeu ainda" # features/step_definitions/authentication_steps.rb:40

  Cenário: Visualizar formulário fechado com respostas # features/visualizar_respostas_admin.feature:34
    Dado que existe um formulário em status "Fechado"  # features/step_definitions/form_steps.rb:31
    E 2 alunos responderam antes de fechar             # features/step_definitions/admin_response_steps.rb:103
    Quando acesso a página do formulário               # features/step_definitions/admin_response_steps.rb:175
    Então devo ver o badge "Fechado"                   # features/step_definitions/admin_response_steps.rb:224
    E devo conseguir ver as 2 respostas coletadas      # features/step_definitions/admin_response_steps.rb:228

  Cenário: Admin pode acessar formulários de outros admins # features/visualizar_respostas_admin.feature:41
    Dado que existe um formulário criado por outro admin   # features/step_definitions/admin_response_steps.rb:148
    Quando acesso esse formulário                          # features/step_definitions/admin_response_steps.rb:185
    Então devo conseguir visualizar o formulário           # features/step_definitions/admin_response_steps.rb:232
    E devo conseguir ver as respostas                      # features/step_definitions/admin_response_steps.rb:236

  Cenário: Usuário não-admin não consegue visualizar respostas # features/visualizar_respostas_admin.feature:48
    Dado que sou um usuário dicente autenticado                # features/step_definitions/template_steps.rb:15
    E existe um formulário publicado                           # features/step_definitions/admin_response_steps.rb:169
    Quando tento acessar a página admin do formulário          # features/step_definitions/admin_response_steps.rb:189
    Então devo ser redirecionado para a página inicial         # features/step_definitions/template_steps.rb:140

34 scenarios (34 passed)
230 steps (230 passed)
0m1.401s
```

---

## 4. Documentação com RDoc

Após a instalação do RDoc no Gemfile e a documentação dos métodos nos arquivos de model, controller e service, o comando `rdoc app/models app/controllers app/services` foi executado, obtendo o seguinte retorno:

```ruby
bgrod@Bernardo:~/sprint3/CAMAAR-Grupo-10$ rdoc app/models app/controllers app/services
Parsing sources...
100% [18/18]  app/services/import_service.rb

Generating Darkfish format into /home/bgrod/sprint3/CAMAAR-Grupo-10/doc...

You can visit the home page at: file:///home/bgrod/sprint3/CAMAAR-Grupo-10/doc/index.html

  Files:      18

  Classes:    18 (1 undocumented)
  Modules:     2 (0 undocumented)
  Constants:   1 (0 undocumented)
  Attributes:  3 (3 undocumented)
  Methods:    44 (0 undocumented)

  Total:      68 (4 undocumented)
   94.12% documented

  Elapsed: 0.3s
```

Isso indica que tudo ocorreu corretamente. Caso queira, basta abrir o arquivo index.html dentro da pasta doc e analisar a documentação do projeto.