class PointCardIssue < ApplicationRecord
  belongs_to :user
  belongs_to :point_card
  has_many :points

  validates :point_card_id, uniqueness: { scope: [:user_id] }
  validates :point_card_id, uniqueness: { scope: [:no] }
  validates :no, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :point, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def issuee?(user)
    user_id == user.id
  end

  def self.issued_to(user)
    PointCardIssue
      .includes(:point_card)
      .where(user_id: user.id)
  end

  def total(now = Time.zone.now)
    latest = Point.latest(self)
    return 0 unless latest
    expired_points = Point.expirable_points(self, now).sum(:remaining_point)
    latest - expired_points
  end

  def update_points_expired_status(limit, issuer = nil)
    ActiveRecord::Base.transaction do
      self.lock!
      latest = Point.latest(self)
      return unless latest
      
      expirable_points = Point.expirable_points(self, limit)
      return unless expirable_points

      total = latest.total
      expirable_points.each do |expirable_point|
        if expirable.remaining_point == 0
          total -= expirable_point.remaining_point
          new_point = Point.new
          new_point.issuer = issuer
          new_point.point = -expirable_point.remaining_point
          new_point.total = total
          new_point.save!
        end

        expirable_point.expired = true
        expirable_point.remaining_point = 0
        expirable_point.save! 
      end
    end
  end

  def issue_point(point, expires_in = nil, now = Time.zone.now, issuer = nil)
    ActiveRecord::Base.transaction do
      self.lock!
      total = point

      # Calc total
      latest = Point.latest(self)
      if latest
        total += latest.total
      end

      # Point can't be nagative
      return if !latest && point < 0

      # Update total
      self.point = total
      self.save!
      
      # Create new point
      new_point = Point.new
      new_point.point_card_issue = self
      new_point.issuer = issuer
      new_point.issued_at = now
      new_point.total = total
      new_point.point = point
      if expires_in && point > 0
        new_point.remaining_point = point
        new_point.expired = false
        new_point.expires_in = expires_in
        new_point.expired_at = now + expires_in.minutes
      end
      new_point.save!

      # Reduce remaing point
      if point < 0
        remaining_point = point
        unexpired_points = Point.unexpired_points(self)
        unexpired_points.each do |unexpired_point|
          remaining_point += unexpired_point.remaining_point
          unexpired_point.remaining_point = remaining_point < 0 ? 0 : remaining_point
          unexpired_point.save!
          break if remaining_point >= 0
        end
      end
      return new_point
    end
  end
end
