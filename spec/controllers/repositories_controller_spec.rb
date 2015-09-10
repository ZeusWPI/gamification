describe RepositoriesController, type: :controller do
  describe 'GET index' do
    it 'returns http success' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @repo = create :repository
      get :show, id: @repo
      expect(response).to be_success
    end
  end
end
