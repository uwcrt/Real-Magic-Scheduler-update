require 'spec_helper'

describe "users/index" do
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
