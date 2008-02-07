= Capigen

Capistrano recipes and templates.

== Install recipes

To install an application, use the install recipes; cap nginx:install

To install a group of applications based on a "profile":

  cap install

_You may need to comment out "Defaults requiretty" in /etc/sudoders on the image before capistrano recipes will work._


== Generating a Capfile

From a rails project:

  rake capigen
  
  
== Deploying (application)

If this is the first time you've deployed you'll need to run:

  cap deploy:setup

Otherwise, your deploy options:
  
  cap deploy

  cap deploy:migrations (deploys and does migration)
  
  cap deploy:migrate (only does migration on existing deployment)
