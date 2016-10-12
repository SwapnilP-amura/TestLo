require 'spec_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "Check All Request" do
    it "Get Home Page" do
      get :home
      expect(response.status).to eq (200)
    end
    it "Get Error Page" do
      get :error
      expect(response.status).to eq (200)
    end
    it "Get Not found Page" do
      get :not_found
      expect(response.status).to eq (200)
    end
  end
end
