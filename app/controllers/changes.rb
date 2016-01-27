Embadge::App.controllers :changes do

  get :new, map: '/badges/:id/change/new' do
    if is_logged_in?
      @badge = Badge.find params[:id]
      @change = BadgeChange.new badge: @badge, user: current_user
      @change.votes.build
      render 'new'
    else
      redirect url(:static, :index)
    end
  end

  post :create do
    @info = BadgeChange.new(params[:badge])
    @info.user = current_user

    if @info.save
      redirect(url(:badges, :show, id: @info.badge.id))
    else
      flash.now[:error] = "Nope"
      render 'changes/new'
    end
  end
end
