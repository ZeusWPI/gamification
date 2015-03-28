RSpec.describe WebhooksController, :type => :controller do
  context 'repository' do
    before :each do
      Organisation.create name: 'ZeusWPI'
    end

    context 'received webhook' do
      before :each do
        json = File.read("spec/github_jsons/repo_create.json")
        request.headers['X-Github-Event'] = 'repository'
        post :receive, payload: json
      end

      it 'creates a repository' do
        expect(Repository.count).to eq(1)
      end

      it 'sets correct name' do
        expect(Repository.find_by name: 'glowing-octo-dubstep').to be
      end
    end

  end

  # Commits require lots of spoofing to test.
  # They have been manually verified.

  context 'issue' do
    before :each do
      @zeus = Organisation.create name: 'ZeusWPI'
      @god = Repository.create name: 'glowing-octo-dubstep', organisation: @zeus
    end

    context 'received webhook' do
      before :each do
        json = File.read("spec/github_jsons/issue_open.json")
        request.headers['X-Github-Event'] = 'issues'
        post :receive, payload: json
      end

      it 'creates a new issue' do
        expect(@god.issues.count).to eq(1)
      end

      context 'closed' do
        before :each do
          json = File.read("spec/github_jsons/issue_close.json")
          request.headers['X-Github-Event'] = 'issues'
          post :receive, payload: json
        end

        it 'closes the issue' do
          expect(@god.issues.where.not(closed_at: nil).count).to eq(1)
        end
      end
    end
  end
end
