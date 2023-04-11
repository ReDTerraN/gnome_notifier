class update_notifier {
    $notify_interval 	= 	lookup('update_notifier::notify_interval', undef, undef, 3600)
    $message 		=	lookup('update_notifier::message', undef, undef, 'please update') 

  package { 'pacman-contrib':
    ensure => installed,
  }
  
file { '/usr/local/bin/check-update':
  source => 'puppet:///modules/update_notifier/check-update.sh',
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
#  notify => Service['puppet'],
}
  
file { '/usr/local/bin/update-notify':
  source => 'puppet:///modules/update_notifier/update-notify.sh',
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
#  notify => Service['puppet'],
}  

exec { '/usr/local/bin/update-notify':
  refreshonly => true,
  subscribe   => File['/usr/local/bin/update-notify'],
}

}
