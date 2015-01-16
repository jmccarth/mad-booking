namespace :deploy do
  desc "Copy fontawesome files"
  task :copy_fontawesome do
    on roles(:all) do |host|
      execute "cp #{current_path}/app/assets/fonts/fontawesome-webfont.woff #{current_path}/public/assets/fontawesome-webfont.woff"
      execute "cp #{current_path}/app/assets/fonts/fontawesome-webfont.ttf #{current_path}/public/assets/fontawesome-webfont.ttf"
    end
  end
end
