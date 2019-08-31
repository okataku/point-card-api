class PointCards::IssuesController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def show
    unless this_issue
      not_found(PointCardIssue)
      return
    end

    unless this_issue.point_card.collaborator?(current_user) || this_issue.issuee?(current_user)
      not_found(PointCardIssue)
      return
    end
    
    render_issue(this_issue)
  end

  def create
    unless this_point_card
      not_found(PointCard)
      return
    end

    begin
      ActiveRecord::Base.transaction do
        this_point_card.lock!
        @issue = this_point_card.new_issue(current_user)
        @issue.save!
        this_point_card.save!
      end
    rescue ActiveRecord::RecordInvalid
      if @issue.errors.any?
        unprocessable_entity(PointCardIssue, @issue.errors)
        return
      end
    end

    render_issue(@issue, :created)
  end

  def delete
    unless this_issue
      not_found(PointCardIssue)
      return
    end

    unless this_issue.issuee?(current_user)
      not_found(PointCardIssue)
      return
    end

    this_issue.destroy!
    no_content
  end

  private

  def this_point_card
    unless @_this_point_card
      @_this_point_card = PointCard
        .includes(:collaborators)
        .find_by(name: params[:point_card_name])
    end
    @_this_point_card
  end

  def this_issue
    unless @_this_issued_point_card
      @_this_issued_point_card = PointCardIssue
        .includes(:point_card, :user)
        .find_by(
          point_cards: { name: params[:point_card_name] },
          no: params[:no]
        )
    end
    @_this_issued_point_card
  end

  def render_issue(issue, status = :ok)
    @issue = issue
    render "/point_cards/issue",
      status: status,
      format: "json",
      builder: "jbuilder"
  end
end
