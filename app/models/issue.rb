# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  open          :boolean          not null
#  title         :string(255)      default("Untitled"), not null
#  body          :text(255)
#  issuer_id     :integer          not null
#  labels        :text             not null
#  assignee_id   :integer
#  milestone     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  repository_id :integer
#

class Issue < ActiveRecord::Base
  belongs_to :issuer,   class_name: :Coder,
                        inverse_of: :created_issues,
                        foreign_key: 'issuer_id'
  belongs_to :assignee, inverse_of: :assigned_issues, 
                        class_name: 'Coder'
  belongs_to :repository
  has_many :bounties

  serialize :labels

  def total_bounty_value
    bounties.map {|b| b.absolute_value}.sum
  end

  def close time: Time.now
    bounties.each { |b| b.claim }
    update! closed_at: time
    save!
  end

  def self.find_or_create_from_hash json, repo
    puts "repository:"
    p repo.inspect
    Issue.find_or_create_by number: json['number'],
                            repository: repo do |issue|
      issue.github_url = json['html_url']
      issue.number     = json['number']
      issue.title      = json['title']
      issue.body       = json['body']
      issue.issuer     = Coder.find_or_create_by_github_name(json['user']['login'])
      issue.labels     = (json['labels'] || []).map  { |label| label.name }
      issue.milestone  = json['milestone'].try(:[], :title)
      issue.opened_at  = DateTime.parse(json['created_at'])

      closed_at = json['closed_at']
      issue.closed_at  = DateTime.parse(closed_at) if closed_at

      unless json['assignee'].blank?
        issue.assignee =
          Coder.find_or_create_by_github_name(json['assignee']['login'])
      end
    end
  end
end
