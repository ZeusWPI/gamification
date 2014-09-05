class Issue < ActiveRecord::Base
  belongs_to :coder, inverse_of: :created_issues, foreign_key: 'issuer_id'
  has_one :assignee, inverse_of: :assigned_issues,
                     class_name: 'Coder', foreign_key: 'assignee_id'
  has_many :bounties

  serialize :labels

  def find_bounty_by_coder coder
    bounty = bounties.where(coder: coder).first
    bounty.present? ? bounty.value : 0
  end

  def self.create_from_hash json, repo
    issue = Issue.new({
      github_url: json.html_url,
      number:     json.number,
      repo:       repo,
      open:       json.state == 'open',
      title:      json.title,
      body:       json.body,
      issuer_id:  Coder.find_or_create_by_github_name(json.user.login).id,
      labels:     json.labels.map { |label| label.name },
      milestone:  json.milestone.try(:[], :title)
    })
    unless json.assignee.blank?
      assignee = Coder.find_by_github_name(json.assignee.login)
      issue.assignee_id = assignee.id unless assignee.nil?
    end
    issue.save!
  end
end
