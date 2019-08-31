class PointCards::Issues::PointsController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    unless this_issue
      not_found(PointCardIssue)
      return
    end

    render_points(this_points)
  end

  def create
    unless this_issue
      not_found(PointCardIssue)
      return
    end

    now = Time.zone.now

    # Update expiration
    this_issue.update_points_expired_status(now)

    # Issue or collect the point.
    point = this_issue.issue_point(point_params[:point], point_params[:expires_in], now, current_user)
    render_point(point, :created)
  end

  private

  def point_params
    params.permit(:point, :expires_in)
  end

  def this_issue
    unless @_this_issue
      @_this_issue = PointCardIssue
        .includes(:point_card)
        .find_by(
          no: params[:no].to_i,
          point_cards: { name: params[:point_card_name] })
    end
    @_this_issue
  end

  def this_points
    return nil unless this_issue
    unless @_this_points
      @_this_points = Point
        .where(point_card_issue_id: this_issue.id)
    end
    @_this_points
  end

  def render_points(points)
    @points = points
    render "/point_cards/issues/points",
      status: :ok,
      format: "json",
      builder: "jbuilder"
  end

  def render_point(point, status = :ok)
    @point = point
    render "/point_cards/issues/point",
      status: :status,
      format: "json",
      builder: "jbuilder"
  end
end
