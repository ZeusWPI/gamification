# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  open          :boolean          not null
#  title         :string(255)      default("Untitled"), not null
#  body          :string(255)
#  issuer_id     :integer          not null
#  labels        :text             not null
#  assignee_id   :integer
#  milestone     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  repository_id :integer
#

class Issue < ActiveRecord::Base
  belongs_to :coder, inverse_of: :created_issues, foreign_key: 'issuer_id'
  belongs_to :assignee, inverse_of: :assigned_issues,
                     class_name: 'Coder'
  belongs_to :repository
  has_many :bounties

  serialize :labels

  def find_bounty_by_coder coder
    bounty = bounties.where(coder: coder).first
    bounty.present? ? bounty : bounties.build(value: 0)
  end

  def total_bounty_value
    bounties.map {|b| b.absolute_value}.sum
  end

  def close
    bounties.each { |b| b.cash_in }
    update! open: false
    save!
  end

  def self.create_from_hash json, repo_name
    issue = Issue.new({
      github_url: json['html_url'],
      number:     json['number'],
      repository: Repository.find_or_create_by(name: repo_name),
      open:       json['state'] == 'open',
      title:      json['title'],
      body:       json['body'],
      issuer_id:  Coder.find_or_create_by_github_name(json['user']['login']).id,
      labels:     (json['labels'] || [] ).map { |label| label.name },
      milestone:  json['milestone'].try(:[], :title)
    })
    unless json['assignee'].blank?
      assignee = Coder.find_by_github_name(json['assignee']['login'])
      issue.assignee_id = assignee.id unless assignee.nil?
    end
    issue.save!
  end
end
