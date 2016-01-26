Embadge::App.controllers :badges do

  get :index do
    if is_logged_in?
      @badges = current_user.badges.order('created_at DESC')
      render 'index'
    else
      flash[:error] = "You need to log in to view your badges."
      redirect(url(:static, :index))
    end
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

  get :github, map: '/v1/:username/:repo/:branch/:package', provides: :svg, cache: true do
    cache_key { [params[:username], params[:repo], params[:branch], params[:package]].join('$') }

    main_key = [params[:username], params[:repo], params[:branch]].join('$')
    Embadge::App.cache[main_key] = (Embadge::App.cache[main_key] || []) << params[:package]


    # Fetch info from Github
    file = 'package.json'
    file = 'bower.json' if params[:package] == 'ember'

    url = "https://raw.githubusercontent.com/#{params[:username]}/#{params[:repo]}/#{params[:branch]}/#{file}"
    label = params[:label] || params[:package]
    package = params[:package]

    response = Unirest.get url
    if response.code == 200
      body = response.body
      version = (body["dependencies"] && body["dependencies"][package]) ||
              (body["devDependencies"] && body["devDependencies"][package])


      options = { label: label }
      options[:start] = version if SemanticRange.valid(version)
      options[:range] = version if SemanticRange.valid_range(version)

      config = badge_config(options)

      content_type "image/svg+xml"
      render 'static', layout: false, locals: config
    else
      status response.code
    end
  end

  post :webhook, map: '/v1/webhook', csrf_protection: false do
    # Invalidate cache
    # Main Key: user$repo$branch
    # Package Keys: user$repo$branch$package
    json = JSON.parse request.body.read
    ref = json["ref"]
    ref_match = ref.match(/^refs\/heads\/(\w+)$/) if ref

    # Do we have a valid ref?
    if ref && ref_match
      branch = ref_match[1]
      repo = json["repository"]["name"]
      username = json["repository"]["owner"]["name"]

      key = [username, repo, branch].join('$')
      if Embadge::App.cache.key?(key)
        Embadge::App.cache[key].each do |package|
          Embadge::App.cache.delete [username, repo, branch, package].join('$')
        end
        Embadge::App.cache.delete key
      end
    end
  end

  # In memory cached version of badge
  get :render, with: :id, map: '/b/', provides: :svg, cache: true do
    expires 30
    badge = Badge.find_by_id(params[:id])

    if badge
      options = badge_config(badge.definition)

      content_type 'image/svg+xml'
      render 'render', layout: false, locals: options
    else
      status 404
    end
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
    if @badge
      if @badge.user == current_user
        render 'edit'
      else
        status 401
        flash.now[:error] = "You are not allowed to edit this badge"
      end
    else
      status 404
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
