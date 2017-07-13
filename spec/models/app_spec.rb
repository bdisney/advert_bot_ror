require 'rails_helper'

RSpec.describe App, type: :model do
  it { should have_many :accounts }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_presence_of :platform_id }
  it { should validate_presence_of :block_types }
  it { should validate_numericality_of(:platform_id).only_integer.is_greater_than(0) }
end
