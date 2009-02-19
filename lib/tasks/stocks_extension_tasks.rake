namespace :radiant do
  namespace :extensions do
    namespace :stocks do
      
      desc "Runs the migration of the Stocks extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          StocksExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          StocksExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Stocks to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from StocksExtension"
        Dir[StocksExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(StocksExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
