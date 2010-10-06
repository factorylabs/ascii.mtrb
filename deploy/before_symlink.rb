node[:applications].each do |app_name, data|
  on_app_servers do
    run "cd #{release_path} && RACK_ENV=#{node[:environment][:framework_env]} bundle exec jekyll"
  end
end