describe Organisation do
  it 'has a valid factory' do
    expect(create :organisation).to be_valid
  end
end
