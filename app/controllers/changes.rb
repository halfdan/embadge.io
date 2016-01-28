Embadge::App.controllers :changes do

  get :new, map: '/badges/:id/change/new' do
    if is_logged_in?
      @badge = Badge.find params[:id]
      @change = BadgeChange.new badge: @badge, user: current_user
      render 'new'
    else
      redirect url(:static, :index)
    end
  end

  post :create, map: '/badges/:id/change/' do
    if is_logged_in?
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
  end

  put :accept, map: '/changes/:change_id/accept' do
  end

  put :reject, map: '/changes/:change_id/reject' do
  end
end
