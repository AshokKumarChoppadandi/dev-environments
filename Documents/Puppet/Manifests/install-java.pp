$packages = ['java-1.8.0-openjdk-devel']

package { $packages:
  ensure => "installed",
}
