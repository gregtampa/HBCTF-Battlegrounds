class parameterised_website::install {
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)

  # Parse out parameters
  $business_name = $HBCTF-Battlegrounds_parameters['business_name'][0]
  $business_motto = $HBCTF-Battlegrounds_parameters['business_motto'][0]
  $manager_profile = parsejson($HBCTF-Battlegrounds_parameters['manager_profile'][0])
  $business_address = $HBCTF-Battlegrounds_parameters['business_address'][0]
  $office_telephone = $HBCTF-Battlegrounds_parameters['office_telephone'][0]
  $office_email = $HBCTF-Battlegrounds_parameters['office_email'][0]
  $industry = $HBCTF-Battlegrounds_parameters['industry'][0]
  $product_name = $HBCTF-Battlegrounds_parameters['product_name'][0]
  $employees = $HBCTF-Battlegrounds_parameters['employees']
  $strings_to_leak = $HBCTF-Battlegrounds_parameters['strings_to_leak']
  $main_page_paragraph_content = $HBCTF-Battlegrounds_parameters['main_page_paragraph_content']
  $images_to_leak = $HBCTF-Battlegrounds_parameters['images_to_leak']

  $security_audit = $HBCTF-Battlegrounds_parameters['security_audit']
  $acceptable_use_policy = str2bool($HBCTF-Battlegrounds_parameters['host_acceptable_use_policy'][0])

  $visible_tabs = $HBCTF-Battlegrounds_parameters['visible_tabs']
  $hidden_tabs = $HBCTF-Battlegrounds_parameters['hidden_tabs']

  $docroot = '/var/www'

  if $acceptable_use_policy {  # Use alternative intranet index.html template
    $index_template = 'parameterised_website/intranet_index.html.erb'
  } else {
    $index_template = 'parameterised_website/index.html.erb'
  }

  # Move boostrap css+js over
  file { "$docroot/css":
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/parameterised_website/css',
  }
  file { "$docroot/js":
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/parameterised_website/js',
  }

  # Apply default CSS template
  file { "$docroot/css/default.css":
  ensure => file,
  content => template('parameterised_website/default.css.erb')
  }

  # Apply index page template
  file { "$docroot/index.html":
    ensure  => file,
    content => template($index_template),
  }

  # Apply contact page template
  file { "$docroot/contact.html":
    ensure  => file,
    content => template('parameterised_website/contact.html.erb'),
  }

  # Create visible tab html files
  unless $visible_tabs == undef {
    $visible_tabs.each |$counter, $visible_tab| {
      if $counter != 0 {
        $n = $counter

        file { "$docroot/tab_$n.html":
          ensure  => file,
          content => $visible_tab,
        }
      }
    }
  }

  # Create hidden tab html files
  unless $hidden_tabs == undef {
    $hidden_tabs.each |$counter, $hidden_tab| {
      if $counter == 0 {
        $n = 0
      } else {
        $n = $counter + $visible_tabs.length - 1  # minus one accounts for the information tab
      }

      file { "$docroot/tab_$n.html":
        ensure  => file,
        content => $hidden_tab,
      }
    }
  }

  ::HBCTF-Battlegrounds_functions::leak_files{ 'parameterised_website-image-leak':
    storage_directory => $docroot,
    images_to_leak => $images_to_leak,
    leaked_from => "parameterised_website",
  }
}