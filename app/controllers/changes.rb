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

  get :vote, map: '/changes/:change_id/vote' do
    change = BadgeChange.proposed.find(params[:change_id])
    if change && current_user.can_vote_for?(change)
      current_user.vote_for change
    end
  end

  get :accept, map: '/changes/:change_id/accept' do
    change = BadgeChange.proposed.find(params[:change_id])
    if change && change.badge.user == current_user
      change.accept!
      redirect(url(:badges, :show, id: @change.badge.id))
    end
  end

  get :reject, map: '/changes/:change_id/reject' do
    change = BadgeChange.proposed.find(params[:change_id])
    if change && change.badge.user == current_user
      change.reject!
      redirect(url(:badges, :show, id: @change.badge.id))
    end
  end
end
