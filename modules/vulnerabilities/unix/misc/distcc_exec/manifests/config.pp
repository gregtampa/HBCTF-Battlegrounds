class distcc_exec::config{
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $leaked_filenames = $HBCTF-Battlegrounds_parameters['leaked_filenames']
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']

  file { '/etc/default/distcc':
    require => Package['distcc'],
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0777',
    content  => template('distcc_exec/distcc.erb')
  }

  # distccd home directory
  file { '/home/distccd/':
    ensure => directory,
    owner => 'distccd',
    mode  =>  '0750',
  }

  #exec usermod home directory for distccd
  exec { 'change-home-dir':
    path => ['/usr/bin/', '/usr/sbin'],
    command => 'usermod -d /home/distccd distccd'
  }

  ::HBCTF-Battlegrounds_functions::leak_files { 'distcc_exec-file-leak':
    storage_directory => "/home/distccd",
    leaked_filenames  => $leaked_filenames,
    strings_to_leak   => $strings_to_leak,
    owner             => 'distccd',
    mode              => '0600',
    leaked_from       => 'distcc_exec',
  }
}