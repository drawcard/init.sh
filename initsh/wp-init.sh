#!/bin/bash
echo "Creating development branch..."
git checkout -b 'dev'

echo "Adding submodules..."
git submodule add https://github.com/BrunoDeBarros/git-deploy-php deploy/git-deploy-php
git submodule add https://github.com/jplew/SyncDB deploy/SyncDB

git submodule add https://github.com/drawcard/roots-sass-dc wp-content/themes/build 

echo "Pull from repo and fetch latest submodules..."
git pull origin master && git submodule update --init --recursive
git submodule status
sleep 1

echo "Adding .gitignore rules for Wordpress..."
echo "

# Wordpress ignores
*.log
.htaccess
sitemap.xml
sitemap.xml.gz
wp-config.php
wp-content/advanced-cache.php
wp-content/backup-db/
wp-content/backups/
wp-content/blogs.dir/
wp-content/cache/
wp-content/upgrade/
wp-content/uploads/
wp-content/wp-cache-config.php 

" >> .gitignore
echo "Rules written to .gitignore."
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

