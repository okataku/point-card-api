class PointCards::OwnedController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    point_cards = PointCard.owned_by(current_user)
    render_owned(point_cards)
  end

  private

  def render_owned(point_cards)
    @point_cards = point_cards
    render '/point_cards',
      status: :ok,
      format: "json",
      handler: "jbuilder"
  end
end
