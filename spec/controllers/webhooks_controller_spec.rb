RSpec.describe WebhooksController, :type => :controller do
  context 'repositories' do
    before :each do
      Organisation.create name: 'ZeusWPI'
    end

    it 'creates a new repository' do
      json = File.read("spec/github_jsons/repo_create.json")

      request.headers['X-Github-Event'] = 'repository'
      post :receive, payload: json

      expect(Repository.find_by name: 'glowing-octo-dubstep').to be
    end
  end
end
