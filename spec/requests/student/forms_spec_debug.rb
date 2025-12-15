require 'rails_helper'

RSpec.describe 'Student::Forms', type: :request do
  let(:student) { create(:user, role: :user, password: 'password123', password_confirmation: 'password123') }
  let(:klass) { create(:klass) }
  let(:form_template) { create(:form_template) }
  let(:form) { create(:form, form_template: form_template, klass: klass, status: :published) }

  def login_as_student
    klass.class_members.create(user: student)
    post user_session_path, params: {
      user: { email: student.email, password: 'password123' }
    }
    puts "\n=== DEBUG LOGIN ==="
    puts "Login response status: #{response.status}"
    puts "Login response location: #{response.location}"
  end

  describe 'GET /student/forms/:id/answer - DEBUG' do
    before { login_as_student }

    it 'prints debug info' do
      puts "\n=== DEBUG ANSWER REQUEST ==="
      get answer_student_form_path(form)
      puts "Answer response status: #{response.status}"
      puts "Answer response location: #{response.location}"
      puts "Answer response body (first 300 chars): #{response.body[0..300]}"
      puts "Form ID: #{form.id}"
      puts "Student ID: #{student.id}"
      puts "Student klasses: #{student.klasses.pluck(:id)}"
      puts "Form klass_id: #{form.klass_id}"
    end
  end
end
