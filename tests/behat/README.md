
## Local Setup

While it is ideal to use VMs or Docker images to share local development environments that are used to run tests, maintaining those VMs can be a huge PITA and requires a decent amount of Docker knowledge. Abstraction layers, like Lando, can be slow as hell and contain a bunch of cruft you don't need.

So, for now it is easiest to setup a local environment on you MacOS laptop to use for running tests at least, if not day-to-day development.

You will need:
- PHP 7 - [Homebrew works well for this step](https://github.com/Homebrew/homebrew-php).
- MySQL - [Homebrew can be used also here](https://gist.github.com/nrollr/3f57fc15ded7dddddcc4e82fe137b58e).
- Composer - Once PHP is installed, [you can install Composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx) locally or globally.
- Drush - Once Composer is installed, `composer global require "drush/drush:8.*"` to install Drush globally. 

You can check the versions of what you have locally, but for this tutorial the versions are as follows:
- PHP `7.1.10`
- MySQL `Server version: 5.7.19 Homebrew`
- Composer `1.5.2`
- Drush `8.1.12`

## Running Tests

You can now install an Express site by downloading Drupal, cloning in the Express profile, and installing the site. 

```bash
ROOT=$(pwd)

# Add Drupal.
drush dl drupal-7.57
mv drupal-7.57 testing

# Make files folder and copy settings.php file.
cd ${ROOT}/testing/sites/default
cp default.settings.php settings.php && chmod 777 settings.php
mkdir files && chmod -R 777 files

# Add the Express profile.
cd ${ROOT}/testing/profiles
git clone git@github.com:CuBoulder/express.git

# Installing the site via Drush in the next step should create the database first,
# but if you have trouble, you can create it manually.
mysql -u root -p
# In MYSQL cli...
> CREATE DATABASE testing;
> exit

# Install site. Need to use your db credentials created when installing MySQL.
drush si express --db-url=mysql://root:@127.0.0.1/testing -y

# Depending on your environment, you might not have a hosting module installed.
# lando_hosting adds users needed for a test run and turns on neccessary bundles. 
# It is the most appropriate hosting module to enable after install, but a local_hosting
# module will be merged into the dev branch soon.
drush en lando_hosting -y

# Start Drush webserver.
drush runserver 127.0.0.1:8069

# Or to run the server process in background.
# I leave it open in another tab to monitor for debugging purposes.
drush runserver 127.0.0.1:8069 > /dev/null 2>&1 &
```

When Express installs, environmental variables are used to determine which "core" to install. If no environment other than the Express deployment servers is found, the "ng_hosting" module will be enabled by default. You can export a variable to enable the Pantheon or other hosting setups, but they might not install the modules and configuration you want. 

It is likely that the hosting modules will be modified to take in local environments and some shared VM solution. For now, you will have "ng_hosting" installed by default. You should be able to login to your account via LDAP, but if not, then use Drush.

```bash
drush uli my-username

# If you need the super user login.
drush uublk 1
drush uli 1
```

Once logged in, make sure that LDAP is in mixed mode by going to "admin/config/people/ldap/authentication" and selecting "Mixed mode. Drupal authentication is tried first. On failure, LDAP authentication is performed."

Next, the Behat dependencies need to be installed before you can run any tests.  

```bash
cd site-path/profiles/express/tests/behat
composer install
```

The test suite uses two different drivers during a test run: one for headless tests and one for browser emulated tests using JavaScript. The JavaScript tests are run via Sauce Labs, and you'll need an API key to use that service and run the tests. You can ask a team member for an API key and username, and they will be shared using LastPass. You'll also need to export those variables. 

The [Sauce Connect Proxy](https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy) uses those auth keys to tunnel into your machine and accept Behat requests. Please download the latest Mac OS version.

```bash
cd sauce-connect-directory

# Start the proxy and wait for the "...you may start your tests" message.
./bin/sc -u username -k access-key
```

The Behat test suite configuration also wants to know the Sauce Labs authorization keys, and while you can pass in configuration to the behat executable per test run, it is much simpler and easy to modify the behat.local.yml file, if it doesn't match your local environment for paths and URLs.

```yaml
#...more config

extensions:
    Behat\MinkExtension:
      base_url: "http://127.0.0.1:8069"
      files_path: "%paths.base%/assets"
      javascript_session: sauce
      sessions:
        default:
          goutte:
            guzzle_parameters:
                verify: false
        sauce:
          sauce_labs:
            # Enter your Sauce Labs credentials.
            username: ""
            access_key: ""
            
#...more config
```

Now you should be able to run the test suite with the following command.

```bash
cd site-path/profiles/express/tests/behat
./bin/behat --config behat.local.yml --verbose --tags '~@exclude_all_bundles&&~broken'
```

## Fixing Broken Tests

The `--verbose` tag should spit out as much information as possible about a failed test run. You will oftentimes see the stacktrace around the failed test and should be able to investigate the files and line numbers given. 

For JavaScript tests, Sauce Labs records the test run so you can go back and actually replay the steps to see what happened. You can also watch the test run as it happens on Sauce Labs to see the output of JavaScript tests in real-time. You will need to have a Sauce Labs account to view the results. Ask a team member if you need access.
