class jenkins::backup {
  bacula::job {
    "${fqdn}-jenkins":
      files => ["/var/lib/jenkins"];
  }
}

