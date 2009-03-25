ActionController::Routing::Routes.draw do |map|
    map.connect "/snips/logout", :action => "logout", :controller => "snips"
    map.connect "/snips/documentation", :action => "documentation", :controller => "snips"
    map.resources :snips
    map.connect "/pages/*path", :action => "render_snip", :controller => "snips"
end


