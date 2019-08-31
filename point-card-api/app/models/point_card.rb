class PointCard < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, length: { in: 2..100 }
  validates :name, format: { with: ValidationPatterns::ID }
  validates :display_name, presence: true
  validates :display_name, length: { in: 2..100 }
  validates :description, length: { maximum: 1000 }

  has_many :collaborators, class_name: :PointCardCollaborator, dependent: :delete_all
  has_many :issue_units,   class_name: :PointIssueUnit,        dependent: :delete_all
  has_many :collect_units, class_name: :PointCollectUnit,      dependent: :delete_all
  has_many :issues,        class_name: :PointCardIssue,        dependent: :delete_all

  def new_owner(user)
    return nil if collaborator?(user)
    PointCardCollaborator.create_owner(self, user)
  end

  def new_maintainer(user)
    return nil if collaborator?(user)
    PointCardCollaborator.create_maintainer(self, user)
  end

  def new_operator(user)
    return nil if collaborator?(user)
    PointCardCollaborator.create_operator(self, user)
  end

  def new_issue(user)
    self.issue_count += 1
    issue = PointCardIssue.new
    issue.no = self.issue_count
    issue.point_card = self
    issue.user = user
    issue.point = 0
    issue
  end

  def new_issue_unit(attributes)
    unit = PointIssueUnit.new(attributes)
    unit.point_card = self
    unit
  end

  def new_collect_unit(attributes)
    unit = PointCollectUnit.new(attributes)
    unit.point_card = self
    unit
  end

  def maintainable_collaborator?(user)
    owner?(user) || maintainer?(user)
  end

  def operable_collaborator?(user)
    collaborator?(user)
  end

  def collaborator?(user)
    owner?(user) || maintainer?(user) || operator?(user)
  end

  def owner?(user)
    collaborators
      .any? {|collaborator| collaborator.user_id == user.id && collaborator.owner? }
  end

  def maintainer?(user)
    collaborators
      .any? {|collaborator| collaborator.user_id == user.id && collaborator.maintainer? }
  end

  def operator?(user)
    collaborators
      .any? {|collaborator| collaborator.user_id == user.id && collaborator.operator? }
  end

  def find_collaborator(user)
    collaborators.find {|collaborator| collaborator.user.uid == user.uid }
  end

  def find_issue_unit(issue_unit)
    issue_units.find {|unit| unit.id == issue_unit.id}
  end

  def find_issue_unit_by_id(issue_unit_id)
    issue_units.find {|unit| unit.id == issue_unit_id}
  end

  def find_collect_unit(collect_unit)
    collect_units.find {|unit| unit.id == collect_unit.id}
  end

  def find_collect_unit_by_id(collect_unit_id)
    collect_units.find {|unit| unit.id == collect_unit_id}
  end

  def self.owned_by(user)
    PointCard
      .includes(:collaborators)
      .where(
        point_card_collaborators: {
          user_id: user.id,
          permission: PointCardCollaborator::PERMISSION_OWNER
        }
      )
  end

  def self.collaborated_with(user)
    PointCard
      .includes(:collaborators)
      .where(point_card_collaborators: { user_id: user.id })
  end
end
