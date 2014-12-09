describe Repository do
  it 'has a valid factory' do
    expect(create :coder).to be_valid
  end
end
