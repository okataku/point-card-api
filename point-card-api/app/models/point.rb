class Point < ApplicationRecord
  belongs_to :issuer, class_name: "User", foreign_key: :issued_by, primary_key: :id
  belongs_to :point_card_issue

  def self.expirable_points(issue, limit)
    Point
      .where(point_card_issue_id: issue.id)
      .where(expired: false)
      .where("expired_at <= ?", limit)
  end

  def self.unexpired_points(issue)
    Point
      .where(point_card_issue_id: issue.id)
      .where(expired: false)
      .order(:expired_at)
  end

  def self.latest(issue)
    Point
      .where(point_card_issue_id: issue.id)
      .order(issued_at: :desc)
      .first
  end
end
