class PointCardsController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    render plain: "Pointcard index"
  end

  def show
    unless this_point_card
      not_found(PointCard)
      return
    end

    render_point_card(this_point_card)
  end

  def create
    point_card = PointCard.new(point_card_params)
    point_card.name = params[:point_card_name]

    if point_card.invalid?
      unprocessable_entity(PointCard, point_card.errors)
      return
    end

    PointCard.transaction do
      point_card.save!
      point_card.new_owner(current_user).save!
    end

    render_point_card(point_card, :created)
  end

  def update
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.maintainable_collaborator?(current_user)
      forbidden(PointCard)
      return
    end

    this_point_card.attributes = point_card_params
    if this_point_card.invalid?
      unprocessable_entity(PointCard, this_point_card.errors)
      return
    end

    this_point_card.save!
    render_point_card(this_point_card)
  end

  def delete
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.owner?(current_user)
      forbidden(PointCard)
      return
    end

    this_point_card.destroy!
    no_content
  end

  private

  def point_card_params
    params.permit(:display_name, :description)
  end

  def this_point_card
    unless @this_point_card
      @this_point_card  = PointCard
        .includes(:collaborators)
        .find_by(name: params[:point_card_nmae])
    end
    @this_point_card
  end

  def render_point_card(point_card, status = :ok)
    @point_card = point_card
    render "/point_card", status: status, format: "json", handler: "jbuilder"
  end
end
