#::ActionController::Routing::RouteSet::Mapper.send(:include, Snips::Routing)
#Snips::SnipsController.prepend_view_path(File.join(File.dirname(File.expand_path(__FILE__)), "views"))

Snips.enumerate_layouts(File.join(File.dirname(File.expand_path(__FILE__)), "../../../app/views/layouts"))
require File.join(File.dirname(__FILE__), "app", "models", "snip.rb")