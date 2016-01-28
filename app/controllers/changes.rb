Embadge::App.controllers :changes do
  before do
    login_required
  end

  get :new, map: '/badges/:id/change/new' do
    @badge = Badge.find params[:id]
    @change = BadgeChange.new badge: @badge, user: current_user
    render 'new'
  end

  post :create, map: '/badges/:id/change/' do
    @change = BadgeChange.new(params[:badge_change])
    @badge = Badge.find params[:id]
    @change.badge = @badge
    @change.user = current_user

    if @change.save
      redirect(url(:badges, :show, id: @change.badge.id))
    else
      flash.now[:error] = "Nope"
      render 'changes/new'
    end
  end

  put :accept, map: '/changes/:change_id/accept' do
    change = BadgeChange.proposed.find(params[:change_id])
    if change && change.badge.user == current_user
      change.accept!
    end
  end

  put :reject, map: '/changes/:change_id/reject' do
    change = BadgeChange.proposed.find(params[:change_id])
    if change && change.badge.user == current_user
      change.reject!
    end
  end
end
