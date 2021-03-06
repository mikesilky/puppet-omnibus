class PuppetOmnibus < FPM::Cookery::Recipe
  homepage 'https://github.com/andytinycat/puppet-omnibus'

  section 'Utilities'
  name 'puppet-omnibus'
  version '3.3.2'
  description 'Puppet Omnibus package'
  revision 0
  vendor 'fpm'
  maintainer '<github@tinycat.co.uk>'
  license 'Apache 2.0 License'

  source '', :with => :noop

  omnibus_package true
  omnibus_dir     "/opt/#{name}"
  omnibus_recipes 'libyaml',
                  'ruby',
                  'mcollective',
                  'puppet',
                  'aws'

  # Set up paths to initscript and config files per platform
  platforms [:ubuntu, :debian] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/default/puppet',
                 '/etc/default/mcollective',
                 '/etc/mcollective/server.cfg',
                 '/etc/mcollective/client.cfg'

  end
  platforms [:fedora, :redhat, :centos] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/sysconfig/puppet',
                  '/etc/sysconfig/mcollective',
                 '/etc/mcollective/server.cfg',
                 '/etc/mcollective/client.cfg'

  end
  omnibus_additional_paths config_files, '/var/lib/puppet/ssl/certs',
                                         '/var/run/puppet',
                                         '/etc/mcollective/plugin.d',
                                         '/etc/mcollective/ssl/clients',
                                         '/etc/init.d/mcollective'
  def build
    # Nothing
  end

  def install
    # Set paths to package scripts
    self.class.post_install builddir('post-install')
    self.class.pre_uninstall builddir('pre-uninstall')
    self.class.post_uninstall builddir('post-uninstall')
  end

end

