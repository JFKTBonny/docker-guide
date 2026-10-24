# Ruby on Rails

Rails 7.1 and newer generates a production-ready `Dockerfile` automatically when you create a project:

```bash
rails new myapp
```

For an existing app, generate one with:

```bash
bundle add dockerfile-rails --group development
bin/rails generate dockerfile
```

Build and run:

```bash
docker build -t rails-app .
docker run -d --name rails-app -p 3000:3000 -e RAILS_MASTER_KEY=$(cat config/master.key) rails-app
```

Open http://localhost:3000
