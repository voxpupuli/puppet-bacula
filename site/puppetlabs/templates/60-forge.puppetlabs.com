<VirtualHost 66.228.54.166:80>
  #ServerName forge.puppetlabs.com
  ServerName oldforge.puppetlabs.com
  ServerAlias forge.puppetlabs.com
  DocumentRoot /opt/forge/public/

 
  RewriteEngine On
  RewriteRule ^/(.*) http://newforge.puppetlabs.com/%{REQUEST_URI}

#  RewriteEngine On
#  RewriteCond %{HTTPS} off
#  RewriteRule ^/users(.*) https://%{HTTP_HOST}%{REQUEST_URI}

  <Directory /opt/forge/public/>
    Options None
    AllowOverride AuthConfig
    Order allow,deny
    allow from all
  </Directory>
  ErrorLog /var/log/apache2/forge.puppetlabs.com_error.log
  LogLevel warn
  CustomLog /var/log/apache2/forge.puppetlabs.com_access.log combined
  ServerSignature On
</VirtualHost>
