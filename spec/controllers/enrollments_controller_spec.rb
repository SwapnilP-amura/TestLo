require 'spec_helper'

RSpec.describe EnrollmentsController, type: :controller do

  before(:each) do
    @student_user = create(:student)
    @student_user.password = "admin123"
    @student_user.save
    @student_user.confirm
    sign_in @student_user

    @test_new = build(:test)
    @test_new.marks = 20
    @test_new.active = true
    @test_new.save!
  end
  describe "GET methods" do
    it "TakeTest Methods" do

      get :taketest , test_id: @test_new.id
      expect(response.status).to eq (302)
    end
    it "Finish Test" do
      get :finish , test_id: @test_new.id
      expect(response.status).to eq (302)
    end

    it "Enroll For Test" do
      get :enroll_for_test, test_id: @test_new.id
      expect(response.status).to eq (302)
    end
  end
end
