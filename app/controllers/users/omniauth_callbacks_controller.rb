class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[discord google]

  def discord
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Discord') if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in through Discord. Please register or try signing in later.'
      session["devise.discord_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  # def facebook
  #   @user = User.create_from_provider_data(request.env['omniauth.auth'])
  #   if @user.persisted?
  #     sign_in_and_redirect @user
  #     set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  #   else
  #     flash[:error] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
  #     redirect_to new_user_registration_url
  #   end
  # end

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    @user.save!
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in through Google. Please register or try signing in later.'
      session["devise.google_oauth2_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
    redirect_to root_path
  end
end
