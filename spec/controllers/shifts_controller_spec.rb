require 'spec_helper'

describe ShiftsController do
  render_views

  describe "Authentication" do
    describe "Not logged in" do

      it "should redirect the 'new' page to the login page" do
       get :new
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should redirect the 'index' page to the login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it "should redirect the 'create' action to the login page" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "Logged in as a regular user" do

      before(:each) do
        test_sign_in(create(:user))
      end

      it "should redirect the 'new' page to the root path" do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it "should render the 'index' page" do
        get :index
        expect(response).to be_successful
      end

      it "should redirect the 'create' action to the root path" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    describe "Logged in as an adminstrator" do

      before(:each) do
        test_sign_in(create(:user)).toggle!(:admin)
      end

      it "should render the 'new' page" do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(create(:user))
    end

    it "should be successful" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(create(:user))
      @user.toggle!(:admin)
    end

    it "should be successful" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET copy_shift" do
    before do
      @user = create( :user )
      @shifttype = create( :shift_type )
      @shift = create( :shift )
      @shift.primary_id = @user.id
      @shift.secondary_id = @user.id
      @shift.rookie_id = @user.id
      test_sign_in(create(:user))
    end

    it "renders new shift template" do
      get :copy_shift, params: { id: @shift.id }
      expect(response).to render_template(:new)
    end

    it "copies shift start time" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_select("shift_start_1i", selected: @shift.start.strftime("%Y"))
      expect(response.body).to have_select("shift_start_2i", selected: @shift.start.strftime("%B"))
      expect(response.body).to have_select("shift_start_3i", selected: @shift.start.strftime("%-d"))
      expect(response.body).to have_select("shift_start_4i", selected: @shift.start.strftime("%H"))
      expect(response.body).to have_select("shift_start_5i", selected: @shift.start.strftime("%M"))
    end

    it "copies shift finish time" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_select("shift_finish_1i", selected: @shift.finish.strftime("%Y"))
      expect(response.body).to have_select("shift_finish_2i", selected: @shift.finish.strftime("%B"))
      expect(response.body).to have_select("shift_finish_3i", selected: @shift.finish.strftime("%-d"))
      expect(response.body).to have_select("shift_finish_4i", selected: @shift.finish.strftime("%H"))
      expect(response.body).to have_select("shift_finish_5i", selected: @shift.finish.strftime("%M"))
    end


    it "copies shift name" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_field("shift_name", with: @shift.name)
    end

    it "copies shift location" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_field("shift_location", with: @shift.location)
    end

    it "copies shift type" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_select("shift_shift_type_id", selected: @shift.shift_type.name)
    end

    it "resets primary_id" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_select("shift_primary_id", selected: nil)
    end

    it "resets secondary_id" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_select("shift_secondary_id", selected: nil)
    end

    it "resets rookie_id" do
      get :copy_shift, params: { id: @shift.id }
      expect(response.body).to have_select("shift_rookie_id", selected: nil)
    end
  end

  describe "GET next_week" do
    before do
      @user = create( :user )
      @shifttype = create( :shift_type )
      @shift = create( :shift )
      @shift.primary_id = @user.id
      @shift.secondary_id = @user.id
      @shift.rookie_id = @user.id
      test_sign_in(create(:user))
    end

    it "renders new shift template" do
      get :next_week, params: { id: @shift.id }
      expect(response).to render_template(:new)
    end

    it "copies shift start time" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_select("shift_start_1i", selected: (@shift.start + 1.week).strftime("%Y"))
      expect(response.body).to have_select("shift_start_2i", selected: (@shift.start + 1.week).strftime("%B"))
      expect(response.body).to have_select("shift_start_3i", selected: (@shift.start + 1.week).strftime("%-d"))
      expect(response.body).to have_select("shift_start_4i", selected: (@shift.start + 1.week).strftime("%H"))
      expect(response.body).to have_select("shift_start_5i", selected: (@shift.start + 1.week).strftime("%M"))
    end

    it "copies shift finish time" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_select("shift_finish_1i", selected: (@shift.finish + 1.week).strftime("%Y"))
      expect(response.body).to have_select("shift_finish_2i", selected: (@shift.finish + 1.week).strftime("%B"))
      expect(response.body).to have_select("shift_finish_3i", selected: (@shift.finish + 1.week).strftime("%-d"))
      expect(response.body).to have_select("shift_finish_4i", selected: (@shift.finish + 1.week).strftime("%H"))
      expect(response.body).to have_select("shift_finish_5i", selected: (@shift.finish + 1.week).strftime("%M"))
    end


    it "copies shift name" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_field("shift_name", with: @shift.name)
    end

    it "copies shift location" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_field("shift_location", with: @shift.location)
    end

    it "copies shift type" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_select("shift_shift_type_id", selected: @shift.shift_type.name)
    end

    it "resets primary_id" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_select("shift_primary_id", selected: nil)
    end

    it "resets secondary_id" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_select("shift_secondary_id", selected: nil)
    end

    it "resets rookie_id" do
      get :next_week, params: { id: @shift.id }
      expect(response.body).to have_select("shift_rookie_id", selected: nil)
    end
  end
end
