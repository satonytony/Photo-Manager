class SessionsController < ApplicationController
  def new
  end

  def create
    @email = params[:email].to_s.strip
    errors = []
    errors << "メールアドレスを入力してください" if @email.blank?
    errors << "パスワードを入力してください"     if params[:password].blank?

    if errors.empty?
      user = User.find_by(email: @email.downcase)
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to photos_path
        return
      end
      errors << "メールアドレスとパスワードが一致するユーザーが存在しません"
    end

    @errors = errors
    render :new, status: :unprocessable_content
  end
end
