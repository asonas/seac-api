# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'seac.ason.as'
set :repo_url, 'git@github.com:asonas/seac-api.git'

set :deploy_to, '/var/www/seac.ason.as'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :linked_dirs, %w{tmp/pids vendor/bundle log}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
    on roles(:app), in: :sequence, wait: 5 do
      with rails_env: fetch(:rails_env) do
      end
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  desc 'Start application'
  task :start do
    invoke "unicorn:start"
    with rails_env: fetch(:rails_env) do
    end
  end

  task :reload do
    invoke "unicorn:reload"
    with rails_env: fetch(:rails_env) do
    end
  end

  task :stop do
   invoke "unicorn:stop"
   with rails_env: fetch(:rails_env) do
   end
  end

end
