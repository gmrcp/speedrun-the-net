namespace :db do
  desc "Reseed database task"
  task reseed: ['db:drop', 'db:create', 'db:migrate', 'db:seed'] do
    puts 'Reseeding completed.'
  end
end
