describe Issue do
  it 'has a valid factory' do
    expect(create :issue).to be_valid
  end
end
