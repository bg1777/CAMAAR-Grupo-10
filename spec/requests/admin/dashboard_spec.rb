require 'rails_helper'

RSpec.describe "Admin::Dashboards", type: :request do
  let(:admin) { create(:user, role: :admin, password: 'password123', password_confirmation: 'password123') }

  before do
    post user_session_path, params: {
      user: { email: admin.email, password: 'password123' }
    }
  end

  describe "GET admin dashboard" do
    it "returns http success" do
      get admin_root_path
      expect(response).to have_http_status(:success)
    end
  end
end
