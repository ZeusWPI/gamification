describe BountiesController, type: :controller do
  it 'works' do
    coder = create :coder
    sign_in coder
    get :index
    expect(response.status).to eq(200)
  end
end
