# Real Magic Scheduler

RMS is a web based application written in rails. It was first uesd by the University of Waterloo's Campus Response team to schedule first aid responders for shifts. It allows administrators to create, edit and delete shifts, and it allows users to take shifts given that they meet certain criteria. The numbers of hours each user has completed is automatically tracked.

## Official Haiku

Writing shift program

"Cannot find object named 'shit'"

Oh man not again!

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Install ruby 2.6.0

```
rvm install "ruby-2.6.0" 
```

When doing this I got an error. This fixed it for me

```
brew install gcc49  
```

Then install the necessary gems

```
bundle install
```

Finally install PostgreSQL. 

On Mac:

```
brew install postgresql
```

### Installing

Next clone this repository

```
git clone https://github.com/uwcrt/Real-Magic-Scheduler-update.git
```

Start PostgreSQL:

```
brew services start postgresql
```

And create your database

```
rake db:create:all  
rake db:migrate
```

Finally to use the app manually create your first admin user

```
rails console
u = User.create username: "...", first_name: "...", last_name: "...", admin: true
```

At this point you should be able to start a server locally

```
rails server
```

### Running Tests

```
bundle exec rspec spec
```

### Deployment

Submit a pull request to deploy to the production Heroku server.

### Optional Environment Variables

There should not be any mandatory environment variables. The app should run fine with zero configuration.

* NOTIFICATION_BACKOFF - The minimum amount of time between new shift emails. Default to 3.hours
* TZ - The timezone that the app is running in. Defaults to 'UTC'
* SENDGRID_USERNAME - The sendgrid username used to send emails, no default. Email will not send without this
* SENDGRID_PASSWORD - The sendgrid password used to send emails, no default. Email will not send without this
* WEB_CONCURRENCY - The number of unicorns to run concurrently. Defaults to 3

## Feature Tracking

Features are being tracked [on story board here](https://trello.com/invite/b/B201Kp7Q/2d808de4e536581563281a334d68f9fc/rms)
