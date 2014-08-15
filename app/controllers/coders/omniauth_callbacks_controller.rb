class Coders::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = Coder.from_omniauth(request.env["omniauth.auth"])

    unless @user.blank?
      # This will throw if @user is not activated
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
