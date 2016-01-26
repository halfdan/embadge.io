Embadge::App.controllers :auth do

  get :callback, map: '/auth/:provider/callback' do
    auth = request.env["omniauth.auth"]
    puts auth
    user = User.where(provider: auth['provider'],
                      uid: auth['uid'].to_s).first || User.create_with_omniauth(auth)
    reset_session

    session[:current_user] = user.id

    redirect '/badges'
  end

end
