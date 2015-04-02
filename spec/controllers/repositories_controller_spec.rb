require 'rails_helper'

RSpec.describe RepositoriesController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    it "returns http success" do
      @repo = create :repository
      get :show, id: @repo
      expect(response).to have_http_status(:success)
    end
  end

end
