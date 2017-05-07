class unrealirc_3281_backdoor::configure {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']
  $leaked_filenames = $HBCTF-Battlegrounds_parameters['leaked_filenames']
  $user = $HBCTF-Battlegrounds_parameters['user'][0]
  $group = $HBCTF-Battlegrounds_parameters['group'][0]
  $user_home = "/home/$user"

  if $HBCTF-Battlegrounds_parameters['business_name'] {
    $business_name = $HBCTF-Battlegrounds_parameters['business_name'][0]
    $motd = "Welcome to the $business_name irc server!"
  }
  else{
    $motd = $HBCTF-Battlegrounds_parameters['motd'][0]
  }

  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'], }

  file { '/etc/init.d/unreal':
    ensure   => file,
    mode     => '0755',
    content  => template('unrealirc_3281_backdoor/unreal.erb'),
  }

  file { '/var/lib/unreal/unrealircd.conf':
    ensure   => file,
    mode     => '0600',
    content  => template('unrealirc_3281_backdoor/unrealircd.conf.erb'),
  }

  # Update message of the day w/ param
  file { '/var/lib/unreal/ircd.motd2':
    ensure => file,
    content => $motd
  }

  exec { 'update-motd':
    cwd => '/var/lib/unreal/',
    command => 'cat ircd.motd2 > ircd.motd'
  }

  # Create $user_home dir
  file { $user_home:
    ensure => directory,
  }

  ::HBCTF-Battlegrounds_functions::leak_files { 'unrealirc_3281-file-leak':
    storage_directory => $user_home,
    leaked_filenames  => $leaked_filenames,
    strings_to_leak   => $strings_to_leak,
    owner             => $user,
    leaked_from       => "unrealirc_3281_backdoor",
    mode              => '0600'
  }
}