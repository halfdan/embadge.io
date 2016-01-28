Embadge::App.controllers :votes do
  before do
    login_required
  end

  get :new, map: '/changes/:id/vote/new' do
    @change = BadgeChange.find params[:id]
    @vote = Vote.new badge_change: @change, user: current_user
    render 'new'
  end

  post :create, map: '/changes/:id/vote/create' do
    @vote = Vote.new(params[:vote])
    @change = BadgeChange.find params[:id]
    @vote.badge_change = @change
    @vote.user = current_user

    if @vote.save
      redirect(url(:badges, :show, id: @change.badge.id))
    else
      flash.now[:error] = "Nope"
      render 'votes/new'
    end
  end
end
