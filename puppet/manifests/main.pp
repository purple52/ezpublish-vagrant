Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

$db_name = 'ezpublish'
$db_user = 'ezpublish'
$db_password = 'ezpublish'

$ez_download_base_url = 'http://share.ez.no'
$ez_download_path = 'content/download/131581/713362/version/1/file'
$ez_download_file = 'ezpublish5_community_project-2012.9-gpl-full.tar.gz'

package { ["imagemagick"]:
  ensure  => present,
}

class {'apache':  }
class {'apache::mod::php': }
apache::mod { 'rewrite': }

php::module { ["mysql", "gd", "mcrypt", "imagick", "curl"]:
  notify => Service["httpd"],
}

php::pear{ [ "apc", "pear" ]:
  notify => Service["httpd"],
}

class { 'mysql::server': }
mysql::db { $db_name:
  user     => $db_user,
  password => $db_password
}

archive { "$ez_download_file":
  ensure => present,
  url => "$ez_download_base_url/$ez_download_path/$ez_download_file",
  target => "/tmp/ezpublish/",
  checksum => false
}

