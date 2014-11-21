# AWS Opsworks Cookbooks


The following custom Chef cookbooks are available to be used with [AWS OpsWorks](http://aws.amazon.com/opsworks/).

## AWS-Ubuntu

Configure an AWS Opsworks Ubuntu image with a swapspace. This is aimed at t1.micro instances to prevent "out of memory" issues.

Available recipes for [AWS OpsWorks Lifecycle Events](http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-events.html):
* **Setup**: aws-ubuntu::setup; Adds memory swap

## Wordpress

Configure Wordpress to interact with the MySQL server. It can be used for a fresh install or a restore from a Backup using [BackWPup](http://wordpress.org/plugins/backwpup/).

Available recipes for [AWS OpsWorks Lifecycle Events](http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-events.html):
* **Configure**: wordpress::configure; Create wp-config.php file along with Cronjob

## ProFTPd

Install and configure proftpd to allow Wordpress FTP access:

* **Configure**: proftpd::confgure;

## ApacheCustom

Update apache conf file with Rewrite rules and Alias:

* **Configure**: apache-custom::configure;

## NginxCustom

Update nginx conf file with Rewrite rules and proxy pass:

* **Configure**: nginx-custom::configure;

## Rails Assets

Add rake assets:precompile task for Rails apps after deployment

* **Deploy**: rails-assets::precompile;

## SSH Keys

Add given SSH keys to servers

* **Configure**: ssh-keys::add;
