describe Coders::OmniauthCallbacksController, type: :controller do
  describe 'github auth callback' do
    before :each do
      # Essential for testing a Devise controller. Bypasses routing
      @request.env['devise.mapping'] = Devise.mappings[:coder]
      # Bypasses auth
      info_hash = OmniAuth::AuthHash::InfoHash.new(nickname: 'Procrat')
      auth_hash = OmniAuth::AuthHash.new(info: info_hash)
      @request.env['omniauth.auth'] = auth_hash
    end

    it 'redirects' do
      get :github
      expect(response).to redirect_to('/')
    end
  end
end
