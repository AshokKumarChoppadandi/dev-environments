# Initally, on Puppet Master machine
# Create a Group
#   sudo groupadd testgroup
# Create a User with the above group
#   sudo useradd -g testgroup testuser
# Set password for the User
#   sudo passwd testuser

# Auti generate the manifest file with puppet as

# puppet resource user testuser   -- This will generate a manifest
# puppet resource group testgroup   -- This will generate a manifest

# Copy the above two manifests and save it in a .pp file

group { 'alice':
  ensure   => 'present',
  gid      => 1003,
  provider => 'groupadd',
}

user { 'alice':
  ensure   => 'present',
  gid      => 1003,
  home     => '/home/alice',
  provider => 'useradd',
  shell    => '/bin/bash',
  uid      => 1003,
}

# Creating the user as Sudo User
augeas { 'sudo-admin':
  context => "/files/etc/sudoers",
  changes => [
    "set spec[user = 'alice']/user alice",
    "set spec[user = 'alice']/host_group/host ALL",
    "set spec[user = 'alice']/host_group/command ALL",
    "set spec[user = 'alice']/host_group/command/runas_user ALL",
  ],
}


