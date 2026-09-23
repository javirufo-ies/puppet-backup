# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dominio::quita_ipv6_dns
class dominio::quita_ipv6_dns {
  # 1. Desactivar IPv6 a nivel de kernel (inmediato)
  file { '/etc/sysctl.d/99-disable-ipv6.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1\n",
    notify  => Exec['apply-sysctl-ipv6'],
  }

  exec { 'apply-sysctl-ipv6':
    command     => '/sbin/sysctl -p /etc/sysctl.d/99-disable-ipv6.conf',
    refreshonly => true,
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  # 2. Desactivar IPv6 en GRUB (para que sea persistente tras reinicios)
  file_line { 'grub_disable_ipv6':
    path  => '/etc/default/grub',
    line  => 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT ipv6.disable=1"',
    match => '^GRUB_CMDLINE_LINUX_DEFAULT=".*"$',
    notify => Exec['update-grub-ipv6'],
  }

  exec { 'update-grub-ipv6':
    command     => '/usr/sbin/update-grub',
    refreshonly => true,
    path        => ['/usr/sbin', '/sbin', '/bin', '/usr/bin'],
  }
}


