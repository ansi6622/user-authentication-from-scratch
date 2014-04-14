# Building User Authentication from scratch

This application demonstrates implementing user authentication from scratch.

## Development
1. `bundle install`
1. Create a database by running `psql -d postgres -f scripts/create_databases.sql`
1. Run the migrations in the development database using `rake db:migrate`. If you would
like to migrate to a specific version you can do so using this rake task. Run `rake -T` for
details.
1. `rerun rackup`
    * running rerun will reload app when file changes are detected
1. Run tests using `rspec`. The tests will clean up the database before each test run.

## Migrations on Heroku
To run the migrations on heroku, run `heroku run 'rake db:migrate'`. If you
do not have a Heroku configuration variable named DATABASE_URL, then you will need to create one.
