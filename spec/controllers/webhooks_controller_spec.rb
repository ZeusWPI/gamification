RSpec.describe WebhooksController, :type => :controller do

  context 'with tracked repository' do
    before :all do
      Rails.application.config.organisation = 'ZeusWPI'
      Rails.application.config.repository_filters = {}
    end

    context 'received created-repo webhook' do
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


    # Commits require lots of spoofing to test.
    # They have been manually verified.


    context 'received issue webhook' do
      before :each do
        @god = Repository.create name: 'glowing-octo-dubstep'
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

  context 'with untracked repository' do
    before :all do
      Rails.application.config.organisation = 'Derps Inc'
    end

    context 'received created-repo webhook' do
      before :each do
        json = File.read("spec/github_jsons/repo_create.json")
        request.headers['X-Github-Event'] = 'repository'
        post :receive, payload: json
      end

      it 'did not create a repository' do
        expect(Repository.count).to eq(0)
      end
    end
  end
end
