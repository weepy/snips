module Snips
  class SnipsController < ActionController::Base
    layout "snips"
    #protect_from_forgery :secret => Time.now.to_i.to_s
    before_filter :authenticate, :except => [:render_snip, :documentation]

# extra methods
		def render_snip
      path = params["path"].class == Array ? params["path"].join("/") : params["path"]
      @snip = Snip.find :first, :conditions => ["path = ?", path]

      
      admin = session[:snips] 
      if @snip
        render :text => @snip.render(admin), :layout => @snip.layout
      else
        render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404 and return
        #if admin
        #  @snip = Snip.new :name => name, :section => params["section"] #, :layout => Snip.layouts[0] #"application2"
        #  render :action => "new"
        #else
        #  1. render :file => "#{RAILS_ROOT}/public/404.html",  
        #  2. :status => 404 and return
        #end
      end
    end

    def logout
		  session[:snips] = nil
		  redirect_to '/'
		end

		def documentation
		  text = File.read(File.join(File.dirname(File.expand_path(__FILE__)), "../../README"))  
      render :text => RedCloth.new(text).to_html, :layout => "snips"
		end
#CRUD
		def index
		  
			@snips = Snip.find(:all, :order => "path")
			
		end

		def show
			@snip = Snip.find(params[:id])			
		end

		def new
			@snip = Snip.new params[:snip]
			
		end

		def edit
			@snip = Snip.find(params[:id])
			
			respond_to do |format|
				format.html
				format.js { render :action => "edit", :layout => false }
			end
			
		end

		def create
			@snip = Snip.new(params[:snip])

			if @snip.save
				flash[:notice] = 'Snip was successfully created.'
				redirect_to "/snips"
			else
				render :action => "new"
			end

		end

		def update

			@snip = Snip.find(params[:id])
			if @snip.update_attributes(params[:snip])
				respond_to do |format|
					format.html { 	redirect_to "/snips" }
					format.js { render :text => @snip.render(true), :layout => false }
				end
				
			else
				render :action => "edit"
			end

		end

		def destroy
			@snip = Snip.find(params[:id])
			@snip.destroy
			redirect_to(snips_url)
		end
		
		protected
		
		def authenticate
		  
      if Snips::should_auth 
        if !Snips::check_digest(session[:snips])
          authenticate_or_request_with_http_basic("Snips") do |user, pass|
            session[:snips] = Snips::auth(user, pass)
          end
        end
      else
        session[:snips] = "loggedin"
      end
    end
    
	end
end
