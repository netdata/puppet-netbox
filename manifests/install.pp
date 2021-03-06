# = Class: netbox::install

class netbox::install {
  
  case $::osfamily {
    'Debian': {
       $packages = [ 
         'libffi-dev',
         'libxml2-dev',
         'libxslt1-dev',
         ] 
         
      @package { $packages:
        ensure => present,
        }
        
      realize (
        Package['libffi-dev'],
        Package['libxml2-dev'],
        Package['libxslt1-dev'],
      )
     }
     
    'RedHat': {
       $packages = [ 
         'libffi-devel',
         'libxml2-devel',
         'libxslt-devel',
         ] 
         
      @package { $packages:
        ensure => present,
        }
        
      realize (
        Package['libffi-devel'],
        Package['libxml2-devel'],
        Package['libxslt-devel'],
      )
     }
    
      default: {
        fail("Unsupported osfamily: ${::osfamily} The 'netbox' module only supports osfamily Debian or RedHat.")
     }
  }

  class { '::python':
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'present',
  }

  file { $::netbox::directory:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  archive { "netbox-${::netbox::version}.tar.gz":
    source          => "https://github.com/digitalocean/netbox/archive/v${::netbox::version}.tar.gz",
    path            => "/tmp/netbox-${::netbox::version}.tar.gz",
    extract_command => 'tar xzf %s --strip-components=1',
    extract_path    => $::netbox::directory,
    extract         => true,
  }
}
