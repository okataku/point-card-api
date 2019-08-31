class PointCards::IssueUnitsController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.operable_collaborator?(current_user)
      forbidden(PointCard)
    end
    
    render_issue_units(this_point_card.issue_units)
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

    unless this_point_card
      not_found(PointIssueUnit)
      return
    end

    render_issue_unit(this_issue_unit)
  end

  def create
    unless this_point_card
      not_found(PointCard)
      return
    end

    unless this_point_card.maintainable_collaborator?(current_user)
      forbidden(PontCard)
      return
    end

    issue_unit = this_point_card.new_issue_unit(issue_unit_params)
    
    if issue_unit.invalid?
      unprocessable_entity(PointIssueUnit, issue_unit.errors)
      return
    end

    issue_unit.save!
    render_issue_unit(issue_unit, :created)
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

    unless this_issue_unit
      not_found(PointIssueUnit)
      return
    end

    this_issue_unit.attributes = issue_unit_params

    if this_issue_unit.invalid?
      unprocessable_entity(PointIssueUnit, this_issue_unit.errors)
      return
    end

    this_issue_unit.save!
    render_issue_unit(this_issue_unit)
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

    unless this_issue_unit
      not_found(PointIssueUnit)
      return
    end

    this_issue_unit.destroy!
    no_content
  end

  private

  def issue_unit_params
    params.permit(:name, :description, :point, :expires_in)
  end

  def this_point_card
    unless @_this_point_card
      @_this_point_card =  PointCard
        .includes(:collaborators, :issue_units)
        .find_by(name: params[:point_card_name])
    end
    @_this_point_card
  end

  def this_issue_unit
    return nil unless this_point_card
    unless @_this_issue_unit
      @_this_issue_unit = @_this_point_card.find_issue_unit_by_id(params[:unit_id].to_i)
    end
    @_this_issue_unit
  end

  def render_issue_units(issue_units, status = :ok)
    @issue_units = issue_units
    render "/point_cards/issue_units", status: :status, format: "json", handler: "jbuilder"
  end

  def render_issue_unit(issue_unit, status = :ok)
    @issue_unit = issue_unit
    render "/point_cards/issue_unit", status: :status, format: "json", handler: "jbuilder"
  end
end
