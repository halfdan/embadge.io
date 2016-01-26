Embadge::App.controllers :badges do

  get :index do
    @badges = current_user.badges.order('created_at DESC')
    render 'index'
  end

  get :show, with: :id do
    @badge = Badge.find_by_id(params[:id])
    if @badge
      render 'show'
    else
      status 404
    end
  end

  # Renders badge based on GET-Params
  get :static, map: '/v1/badge', provides: :svg do
    options = badge_config(params)

    content_type 'image/svg+xml'
    render 'static', layout: false, locals: options
  end

  # In memory cached version of badge
  get :render, with: :id, map: '/b/', provides: :svg, cache: true do
    expires 30
    @badge = Badge.find_by_id(params[:id])

    options = badge_config(@badge.definition)

    content_type 'image/svg+xml'
    render 'render', layout: false, locals: options
  end

  post :create do
    params[:badge]
    @badge = Badge.new(params[:badge])
    @badge.user = current_user

    if @badge.save
      redirect(url(:badges, :show, id: @badge.id))
    else
      flash.now[:error] = "Nope"
      render 'badges/new'
    end
  end

  get :edit, with: :id do
    # Only edit
    @badge = Badge.find_by_id(params[:id])
    if @badge.user == current_user
      render 'edit'
    else
      status 401
      flash[:error] = "You are not allowed to edit this badge"
    end
  end

  get :new do
    if is_logged_in?
      @badge = Badge.new
      @badge.badge_infos.build
      render :new
    else
      status 401
      flash[:error] = "You need to log in to create a badge."
      redirect(url(:static, :index))
    end
  end

  delete :delete, with: :id do

  end
end
