#!/bin/bash

# Helps to check errors in the script
set -u

echo "Welcome to the wp-init.sh script."
echo "This script will commit changes along the way to prevent merge conflicts."
echo "This script will begin in 5 seconds. Press ^-C to abort....."
sleep 5
echo "Script started."

cd ..

echo "Creating development branch..."
git checkout -b 'dev'

echo "Adding submodules..."
git submodule add https://github.com/BrunoDeBarros/git-deploy-php deploy/git-deploy-php
git submodule add https://github.com/jplew/SyncDB deploy/SyncDB
git submodule add https://github.com/drawcard/roots-sass-dc wp-content/themes/build 

echo "Pull from repo and fetch latest submodules..."
echo "Committing changes..."
git add .
git commit -m "[wp-init.sh] Added submodules"
git pull origin master && git submodule update --init --recursive
git submodule status
sleep 1

echo "Setting up custom wp-config files..."
git remote add wp-config https://github.com/studio24/wordpress-multi-env-config
git remote update
git fetch wp-config && git fetch wp-config --tags
mv wp-config.php wp-config-original.php
echo "Committing changes..."

git add .
git commit -m "[wp-init.sh] Original wp-config.php file is now wp-config-original.php"
git merge wp-config/master
echo "Done. Read README.md for further instructions to configure the database settings for each environment."
sleep 1

echo "Copy git-deploy-php to root folder..."
cp deploy/git-deploy-php/git-deploy .
cp deploy/git-deploy-php/deploy.ini .
echo "Copy complete. Read deploy/git-deploy-php/README.md for further setup & usage instructions."
sleep 1

echo "Copy db-sync to root folder..."
cp deploy/SyncDB/syncdb .
cp deploy/SyncDB/syncdb-config .
chmod +x syncdb
echo "Copy complete. Read deploy/SyncDB/README.md for further setup & usage instructions."
echo "*** Configure 'syncdb-config' file to finish setting up SyncDB ***"
sleep 1

echo "Adding .gitignore rules for Wordpress..."
echo "
##### Added by wp-init.sh script
### WORDPRESS IGNORES
*.log
.htaccess
sitemap.xml
sitemap.xml.gz

### Leave this commented out if using custom wp-config files
# wp-config.php

wp-content/advanced-cache.php
wp-content/backup-db/
wp-content/backups/
wp-content/blogs.dir/
wp-content/cache/
wp-content/upgrade/
wp-content/uploads/
wp-content/wp-cache-config.php

### WORDPRESS CUSTOM WP-CONFIG FILES
### Uncomment these if you don't want staging / dev DB details to be copied to the production server.
### Useful if you are making your project available to the public.

# wp-config.staging.php
# wp-config.development.php

### IGNORE INIT.SH FOLDER
initsh/

##### End wp-init.sh additions
" >> .gitignore
git rm -rf --cached initsh/
echo "Rules written to .gitignore. and initsh/ folder is now untracked & ignored." 
echo "Be sure to read .gitignore and customise as you need before your first commit."
sleep 1

echo "Committing final changes..."
git add .
git commit -m "[wp-init.sh] Finished setup"
sleep 1

echo "DONE!"
echo "Now that setup has finished, be sure to remove the initsh/ folder."
