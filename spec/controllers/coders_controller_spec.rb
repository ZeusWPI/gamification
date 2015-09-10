describe CodersController, type: :controller do
  describe 'GET show' do
    it 'returns http success' do
      @coder = create :coder
      get :show, id: @coder
      expect(response).to be_success
    end
  end
end
