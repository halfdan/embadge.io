Embadge::App.controllers :auth do

  get :callback, map: '/auth/:provider/callback' do
    auth = request.env["omniauth.auth"]
    puts auth
    user = User.where(provider: auth['provider'],
                      uid: auth['uid'].to_s).first || User.create_with_omniauth(auth)

    session[:user_id] = user.id

    redirect '/badges'
  end

  get :logout do
    log_out
  end
end
