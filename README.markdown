Real Magic Scheduler
--------------------

RMS is a web based application written in rails. It was first uesd by the University of Waterloo's Campus Response team to schedule first aid responders for shifts. It allows administrators to create, edit and delete shifts, and it allows users to take shifts given that they meet certain criteria. The numbers of hours each user has completed is automatically tracked.

Official Haiku
--------------
Writing shift program

"Cannot find object named 'shit'"

Oh man not again!

Optional Environment Variables
------------------------------
There should not be any mandatory environment variables. The app should run fine with zero configuration.

* NOTIFICATION_BACKOFF - The minimum amount of time between new shift emails. Default to 3.hours
* TZ - The timezone that the app is running in. Defaults to 'UTC'
* SENDGRID_USERNAME - The sendgrid username used to send emails, no default. Email will not send without this
* SENDGRID_PASSWORD - The sendgrid password used to send emails, no default. Email will not send without this
* WEB_CONCURRENCY - The number of unicorns to run concurrently. Defaults to 3
