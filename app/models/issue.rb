# == Schema Information
#
# Table name: issues
#
#  id            :integer          not null, primary key
#  github_url    :string(255)      not null
#  number        :integer          not null
#  title         :string(255)      default("Untitled"), not null
#  issuer_id     :integer          not null
#  repository_id :integer          not null
#  labels        :text             not null
#  body          :text
#  assignee_id   :integer
#  milestone     :string(255)
#  opened_at     :datetime         not null
#  closed_at     :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Issue < ActiveRecord::Base
  extend Datenfisch::Model
  belongs_to :issuer,   class_name: :Coder,
                        inverse_of: :created_issues,
                        foreign_key: 'issuer_id'
  belongs_to :assignee, inverse_of: :assigned_issues, 
                        class_name: 'Coder'
  belongs_to :repository
  has_many :bounties

  serialize :labels
  include Schwarm
  stat :total_bounty_value, (BountyFisch.bounty_value *
    Datenfisch.volatile { BountyPoints.bounty_factor })

  def close time: Time.now
    bounties.where(claimed_at: nil).each(&:claim)
    update! closed_at: time
    save!
  end

  def self.find_or_create_from_hash json, repo
    Issue.find_or_create_by number: json['number'],
                            repository: repo do |issue|
      issue.github_url = json['html_url']
      issue.number     = json['number']
      issue.title      = json['title']
      issue.body       = json['body']
      issue.issuer     = Coder.find_or_create_by_github_name(json['user']['login'])
      issue.labels     = (json['labels'] || []).map  { |label| label['name'] }
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
