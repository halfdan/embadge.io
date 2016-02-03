Embadge::App.controllers :static do

  get :index, map: '/' do
    render :index
  end
end
