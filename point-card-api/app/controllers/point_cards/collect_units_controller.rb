class PointCards::CollectUnitsController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.operable_collaborator?(current_user)
      forbidden(PointCard)
      return
    end
    
    render_collect_units(this_point_card.collect_units)
  end

  def show
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.operable_collaborator?(current_user)
      forbidden(PointCard)
      return
    end

    unless this_collect_unit
      not_found(PointIssueUnit)
      return
    end

    render_collect_unit(this_collect_unit)
  end

  def create
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.maintainable_collaborator?(current_user)
      forbidden(PointCard)
      return
    end

    collect_unit = this_point_card.new_collect_unit(collect_unit_params)
    
    if collect_unit.invalid?
      unprocessable_entity(PointCollectUnit, collect_unit.errors)
      return
    end

    collect_unit.save!
    render_collect_unit(collect_unit, :created)
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

    unless this_collect_unit
      not_found(PointCollectUnit)
      return
    end

    this_collect_unit.attributes = collect_unit_params
    
    if this_collect_unit.invalid?
      unprocessable_entity(PointCollectUnit, this_collect_unit.errors)
      return
    end

    this_collect_unit.save!
    render_collect_unit(this_collect_unit)
  end

  def delete
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.maintainable_collaborator?(current_user)
      forbidden(PointCard)
      return
    end

    unless this_collect_unit
      not_found(PointCollectUnit)
      return
    end

    this_collect_unit.destroy!
    no_content
  end

  private

  def collect_unit_params
    params.permit(:name, :description, :point)
  end

  def this_point_card
    unless @_this_point_card
      @_this_point_card =  PointCard
        .includes(:collaborators, :issue_units)
        .find_by(name: params[:point_card_name])
    end
    @_this_point_card
  end

  def this_collect_unit
    return nil unless this_point_card
    unless @_this_collect_unit
      @_this_collect_unit = this_point_card.find_collect_unit_by_id(params[:unit_id].to_i)
    end
    @_this_collect_unit
  end

  def render_collect_units(collect_units, status = :ok)
    @collect_units = collect_units
    render "/point_cards/collect_units", status: status, format: "json", handler: "jbuilder"
  end

  def render_collect_unit(collect_unit, status = :ok)
    @collect_unit = collect_unit
    render "/point_cards/collect_unit", status: status, format: "json", handler: "jbuilder"
  end
end
