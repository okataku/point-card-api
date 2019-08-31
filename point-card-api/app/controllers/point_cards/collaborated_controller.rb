class PointCards::CollaboratedController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    point_cards = PointCard.collaborated_with(current_user)
    render_issued(point_cards)
  end

  private

  def render_issued(point_cards)
    @point_cards = point_cards
    render "/point_cards",
      status: :ok,
      format: "json",
      builder: "jbuilder"
  end
end
