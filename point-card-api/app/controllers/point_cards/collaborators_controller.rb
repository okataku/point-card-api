class PointCards::CollaboratorsController < ApplicationController
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

    render_collaborators(this_point_card.collaborators)
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

    unless this_user
      not_found(User)
      return
    end

    unless this_collaborator
      not_found(PointCardCollaborator)
      return
    end

    render_collaborator(this_collaborator)
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

    unless this_user
      not_found(User)
      return
    end

    collaborator = PointCardCollaborator.new(collaborator_params)
    collaborator.point_card = this_point_card
    collaborator.user = this_user

    if collaborator.invalid?
      unprocessable_entity(PointCardCollaborator.to_s, collaborator.errors)
      return
    end

    if collaborator.owner?
      forbidden(PointCard)
      return
    end

    collaborator.save!
    render_collaborator(collaborator, :created)
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

    unless this_user
      not_found(User)
      return
    end

    unless this_collaborator
      not_found(PointCardCollaborator)
      return
    end

    this_collaborator.attributes = collaborator_params

    if this_collaborator.invalid?
      unprocessable_entity(PointCardCollaborator, this_collaborator.errors)
      return
    end

    if this_collaborator.owner?
      forbidden(PointCard)
      return
    end

    this_collaborator.save!
    render_collaborator(this_collaborator)
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

    unless this_user
      not_found(User)
      return
    end

    unless this_collaborator
      not_found(PointCardCollaborator)
      return
    end

    if this_collaborator.owner?
      forbidden(PointCard)
      return
    end

    this_collaborator.destroy!
    no_content
  end

  private

  def collaborator_params
    params.permit(:permission)
  end

  def this_point_card
    unless @this_point_card
      @this_point_card = PointCard
        .includes(collaborators: [:user])
        .find_by(name: params[:point_card_name])
    end
    @this_point_card
  end

  def this_user
    unless @this_user
      @this_user = User.find_by(uid: params[:uid])
    end
    @this_user
  end

  def this_collaborator
    return nil unless this_point_card && this_user
    unless @this_collaborator
      @this_collaborator = this_point_card.find_collaborator(this_user)
    end
    @this_collaborator
  end

  def render_collaborator(collaborator, status = :ok)
    @collaborator = collaborator
    render "/point_cards/collaborator",
      status: status,
      format: "json",
      builder: "jbuilder"
  end

  def render_collaborators(collaborators)
    @collaborators = collaborators
    render "/point_cards/collaborators",
      status: :ok,
      format: "json",
      builder: "jbuilder"
  end
end
