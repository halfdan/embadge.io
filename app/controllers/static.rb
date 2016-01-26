Embadge::App.controllers :static do

  get :index, map: '/' do
    render :index
  end

  get :badge, map: '/v1/badge.svg' do
        
  end
end
