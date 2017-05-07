class gitlist_040::configure {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $leaked_filenames = $HBCTF-Battlegrounds_parameters['leaked_filenames']
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']
  $images_to_leak = $HBCTF-Battlegrounds_parameters['images_to_leak']

  Exec { path => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'] }

  # Create /home/git/repositories
  file { ['/home/git', '/home/git/repositories']:
    ensure => directory,
    owner  => 'www-data',
  }

  $leaked_files_path = '/home/git/repositories/secret_files'
  file { $leaked_files_path:
    ensure => directory,
    before => Exec['create-repo-file_leak']
  }

  exec { 'create-repo-file_leak':
    cwd     => $leaked_files_path,
    command => "git init",
  }

  $flag = [$strings_to_leak[0]]
  $flag_filename = [$leaked_filenames[0]]
  $public_strings_to_leak = delete_at($strings_to_leak, 0)
  $public_strings_to_leak_filename = delete_at($leaked_filenames, 0)

  ::HBCTF-Battlegrounds_functions::leak_files { 'gitlist_040-flag-leak':
    storage_directory => '/home/git',
    leaked_filenames  => $flag_filename,
    strings_to_leak   => $flag,
    owner             => 'www-data',
    mode              => '0750',
    leaked_from       => 'gitlist_040',
    before            => Exec['initial_commit_leaked_files_repo']
  }

  ::HBCTF-Battlegrounds_functions::leak_files { 'gitlist_040-file-leak':
    storage_directory => $leaked_files_path,
    leaked_filenames  => $public_strings_to_leak_filename,
    strings_to_leak   => $public_strings_to_leak,
    images_to_leak    => $images_to_leak,
    owner             => 'www-data',
    mode              => '0750',
    leaked_from       => 'gitlist_040',
    before            => Exec['initial_commit_leaked_files_repo']
  }

  exec { 'initial_commit_leaked_files_repo':
    cwd     => $leaked_files_path,
    command => "git add *; git commit -a -m 'initial commit'",
  }

  include ::apache::mod::rewrite
  include ::apache::mod::php

  ::apache::vhost { 'www-gitlist':
    port    => '80',
    docroot => '/var/www/gitlist',
    before  => File['/var/www/index.html'],
  }

  # Add link to gitlist from index.html
  file { '/var/www/index.html':
    ensure => file,
    content => '<html><body><a href="/gitlist">Git repositories</a></body></html>'
  }
}