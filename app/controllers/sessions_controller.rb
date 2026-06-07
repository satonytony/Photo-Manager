class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    @email = params[:email].to_s.strip
    errors = []
    errors << t("sessions.errors.email_blank")    if @email.blank?
    errors << t("sessions.errors.password_blank")  if params[:password].blank?

    if errors.empty?
      user = User.find_by(email: @email.downcase)
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to photos_path
        return
      end
      errors << t("sessions.errors.invalid_credentials")
    end

    @errors = errors
    render :new, status: :unprocessable_content
  end

  def destroy
    # 仕様では未ログイン状態に戻るだけと記載あったが、念のためaccess_tokenも削除する
    reset_session
    redirect_to login_path
  end
end
