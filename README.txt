= Capigen

Capistrano plugins, recipes and templates.

== Install recipes

To install an application, use the install recipes. For example:

  cap nginx:install
  
Recipes may have settings that are required, or defaults that can be overriden. These are usually set in "profiles".

To install a group of applications based on a "profile":

  cap install

<em>You may need to comment out "Defaults requiretty" in /etc/sudoders on the image before capistrano recipes will work.</em>


== Profiles

Profiles store lists of recipes to run, and settings for those recipes.

Profiles are capistrano configuration like a Capfile or deploy.rb. See capigen/lib/profiles for more info.


== Generating a Capfile

From a rails project:

  rake capigen
  
  
== Deploying (application)

If this is the first time you've deployed you'll need to run:

  cap deploy:setup

Otherwise, your standard deploy options:
  
  cap deploy

  cap deploy:migrations (deploys and does migration)
  
  cap deploy:migrate (only does migration on existing deployment)
