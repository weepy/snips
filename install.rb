require 'fileutils' 

here = File.dirname(__FILE__)
rails_root = defined?(RAILS_ROOT) ? RAILS_ROOT : "#{here}/../../.."

STDOUT.puts "SNIPS\n****\n"
STDOUT.puts "Copying assets to public directory ..."
FileUtils.cp_r "#{rails_root}/vendor/plugins/snips/assets/snips", "#{rails_root}/public"
STDOUT.puts "... done"
STDOUT.puts "Now read: /vendor/plugins/snips/README :)"