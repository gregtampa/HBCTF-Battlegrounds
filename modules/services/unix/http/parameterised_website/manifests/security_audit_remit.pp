class parameterised_website::security_audit_remit {
  # Pull HBCTF-Battlegrounds Parameters through
  $json_inputs = base64('decode', $::base64_inputs)
  $HBCTF-Battlegrounds_parameters = parsejson($json_inputs)
  $security_audit = $HBCTF-Battlegrounds_parameters['security_audit']

  if $security_audit {
    $security_audit_remit = $security_audit[0]
    $business_name = $HBCTF-Battlegrounds_parameters['business_name'][0]
    $home = '/var/www'

    Exec { path    => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'], }

    # Apply html data
    file{ "$home/security_audit_remit.html":
      ensure  => file,
      content => template('parameterised_website/security_audit_remit_page.html.erb'),
    }
  }
}