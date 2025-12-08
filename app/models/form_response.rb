# app/models/form_response.rb

class FormResponse < ApplicationRecord
  belongs_to :form
  belongs_to :user
  has_many :form_answers, dependent: :destroy

  validates :form_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :form_id, message: 'já respondeu este formulário' }

  accepts_nested_attributes_for :form_answers

  def completed?
    submitted_at.present?
  end

  def pending?
    !completed?
  end
end