# le-renew-certs

This is just a simple script to automatically renew Let's Encrypt SSL Certificates.

The main idea behind the script is to read a configuration file located at $LE_CONFIG_PATH per each domain and renew the SSL certificate when the expiration date is less than $EXP_LIMIT (by default 15 days). Furthermore, it reload the Nginx webserver config in order to load the new certificate/s.

Put it in your crontab!
