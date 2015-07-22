RSpec.describe 'Webhooks', type: :request do
  def post_payload(json, type)
    post '/payload', json,       'Content-Type' => 'application/json',
                                 'X-Github-Event' => type
  end

  it 'should respond to ping' do
    json = File.read('spec/github_jsons/ping.json')
    post_payload json, 'ping'
  end

  context 'with tracked repository' do
    before :all do
      Rails.application.config.organisation = 'ZeusWPI'
      Rails.application.config.repository_filters = {}
    end

    context 'received created-repo webhook' do
      before :each do
        json = File.read('spec/github_jsons/repo_create.json')
        post_payload json, 'repository'
      end

      it 'creates a repository' do
        expect(Repository.count).to eq(1)
      end

      it 'sets correct name' do
        expect(Repository.find_by name: 'glowing-octo-dubstep').to be
      end
    end

    # Fake rugged implementation
    class FakeRepo
      def lookup(sha)
        FakeCommit.new sha
      end
    end

    class FakeCommit
      attr_reader :oid, :time, :parents

      def initialize(sha)
        @oid = sha
        @parents = ['lol']
        @time = Time.zone.now
      end

      def diff(_arg = nil)
        FakeDiff.new
      end
    end

    class FakeDiff
      def stat
        [0, 10, 20]
      end
    end

    context 'received push webhook' do
      before :each do
        @god = create :repository, name: 'glowing-octo-dubstep'
        @iasoon = create :coder, github_name: 'Iasoon'
        @sha = 'be981ec9e53ef639361ffebbf88845c711fb07bd' # From json

        RSpec::Mocks.with_temporary_scope do
          allow(Commit).to receive(:get_committer) { @iasoon }
          allow_any_instance_of(Repository).to receive(:rugged_repo) { FakeRepo.new }
          allow_any_instance_of(Repository).to receive(:pull_or_clone)
          json = File.read('spec/github_jsons/push.json')
          post_payload json, 'push'
        end
      end

      it 'registers the commit' do
        expect(Commit.find_by repository: @god, sha: @sha).to be
      end

      it 'rewarded the commit' do
        @iasoon.reload
        expect(@iasoon.reward_residual).to be > 0
      end
    end

    context 'received issue webhook' do
      before :each do
        @god = create :repository, name: 'glowing-octo-dubstep'
        json = File.read('spec/github_jsons/issue_open.json')
        post_payload json, 'issues'
      end

      it 'creates a new issue' do
        expect(@god.issues.count).to eq(1)
      end

      context 'closed' do
        before :each do
          json = File.read('spec/github_jsons/issue_close.json')
          post_payload json, 'issues'
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
        json = File.read('spec/github_jsons/repo_create.json')
        post_payload json, 'repository'
      end

      it 'did not create a repository' do
        expect(Repository.count).to eq(0)
      end
    end
  end
end
