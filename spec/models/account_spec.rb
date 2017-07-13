require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should have_many :apps }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end