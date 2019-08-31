class PointCards::IssuedController < ApplicationController
  include AccessTokenAuth

  before_action :authenticate_user

  def index
    issues = PointCardIssue.issued_to(current_user)
    render_issues(issues)
  end

  private

  def render_issues(issues)
    @issues = issues
    render "/point_cards/issues",
      status: :ok,
      format: "json",
      builder: "jbuilder"
  end
end
