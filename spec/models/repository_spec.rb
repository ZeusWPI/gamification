describe Repository do
  it 'has a valid factory' do
    expect(create :repository).to be_valid
  end
end
