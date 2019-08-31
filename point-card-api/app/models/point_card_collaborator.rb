class PointCardCollaborator < ApplicationRecord

  PERMISSION_OWNER = "owner"
  PERMISSION_MAINTAINER = "maintainer"
  PERMISSION_OPERATOR = "operator"

  belongs_to :point_card
  belongs_to :user

  validates :point_card_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:point_card_id] }
  validates :permission, presence: true
  validates :permission, inclusion: { in: [PERMISSION_OWNER, PERMISSION_MAINTAINER, PERMISSION_OPERATOR] }

  def self.create(point_card, user)
    $collaborator = new()
    $collaborator.point_card = point_card
    $collaborator.user = user
    $collaborator
  end

  def self.create_owner(point_card, user)
    create(point_card, user).to_owner
  end

  def self.create_maintainer(point_card, user)
    create(point_card, user).to_maintainer
  end

  def self.create_operator
    create(point_card, user).to_operator
  end

  def to_owner
    self.permission = PERMISSION_OWNER
    self
  end

  def to_maintainer
    self.permission = PERMISSION_MAINTAINER
    self
  end

  def to_operator
    self.permission = PERMISSION_OPERATOR
    self
  end

  def owner?
    permission == PERMISSION_OWNER
  end

  def maintainer?
    permission == PERMISSION_MAINTAINER
  end

  def operator?
    permission == PERMISSION_OPERATOR
  end

  def avtive?
    active
  end
end
