class Auth::SignupController < ApplicationController
  def create
    user = User.new(signup_params)

    if (user.invalid?)
      unprocessable_entity User.table_name, user.errors
      return
    end
    
    user.save!
    render_user(user)
  end

  private

  def signup_params
    params.permit(:uid, :email, :password)
  end

  def render_user(user)
    @user = user
    render "/user", formats: "json", handlers: "jbuilder"
  end
end
