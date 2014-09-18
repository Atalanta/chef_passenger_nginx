require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|

  config.platform = 'ubuntu'
  config.version = '14.04'

  describe 'passenger_nginx::default' do

    before(:each) do
      stub_command(/apt-key list/).and_return(false)
    end

    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'includes the default apt-repo recipe' do
      expect(chef_run).to include_recipe 'apt-repo'
    end
    
    it 'adds the Passenger APT repo' do
      expect(chef_run).to run_execute('apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7')
      expect(chef_run).to render_file('/etc/apt/sources.list.d/passenger.list').with_content(/^deb.*oss-binaries\.phusionpassenger\..* trusty main/)
    end 

    it 'adds the Brightbox RubyNG PPA' do
      expect(chef_run).to render_file('/etc/apt/sources.list.d/brightbox_ruby-ng.ppa.list').with_content(/^deb.*ppa\.launchpad\.net\/brightbox\/ruby-ng.*trusty main/)
    end 

    it 'installs nginx' do
      expect(chef_run).to install_package('nginx-full')
    end

    it 'installs passenger' do
      expect(chef_run).to install_package('passenger')
    end
    
    it 'installs Ruby 2.1' do
      expect(chef_run).to install_package('ruby2.1')
      expect(chef_run).to install_package('ruby2.1-dev')
    end

    it 'enables and starts nginx' do
      expect(chef_run).to enable_service('nginx')
      expect(chef_run).to start_service('nginx')
    end

    it 'sets Passenger Ruby and root' do
      expect(chef_run).to render_file('/etc/nginx/nginx.conf').with_content(/^\s+passenger_root.*locations\.ini;$/)
      expect(chef_run).to render_file('/etc/nginx/nginx.conf').with_content(/^\s+passenger_ruby.*\/usr\/bin\/ruby;$/)
    end
 
  end

end
