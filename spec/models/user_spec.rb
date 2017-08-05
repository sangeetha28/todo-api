require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:todos) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email_address) }
  it { should validate_presence_of(:password_digest) }
end
