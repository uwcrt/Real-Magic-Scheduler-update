require 'spec_helper'

describe "users/index" do
  before(:each) do
    allow_any_instance_of(ActionView::TestCase::TestController).to receive(:controller_name).and_return('users')
    @filterrific = Filterrific::ParamSet.new(User, {})
  end

  before do
    assign(:users, [create(:user), create(:user, disabled: true)])
    assign(:shift_types, [create(:shift_type)])
  end

  it "should display rank as position column title" do
    render
    expect(rendered).to have_text('Rank')
  end

  it "should display Active/Suspended under suspended column" do
    render
    expect(rendered).to have_text('Active')
    expect(rendered).to have_text('Suspended')
  end
end
