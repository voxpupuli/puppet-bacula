require 'puppet/provider/package'

Puppet::Type.type(:mysql_database).provide(:mysql,
		:parent => Puppet::Provider::Package) do

	desc "Use mysql as database."
	commands :mysqladmin => '/usr/bin/mysqladmin'
	commands :mysql => '/usr/bin/mysql'
	
        # retrieve the current set of mysql databases
	def self.instances
		dbs = []

		cmd = "#{command(:mysql)} -uuser -ppassword mysql -NBe 'show databases'"
		execpipe(cmd) do |process|
			process.each do |line|
				dbs << new( { :ensure => :present, :name => line.chomp,  } )
			end
		end
		return dbs
	end

	def query
		result = {
			:name => @resource[:name],
			:ensure => :absent
		}

		cmd = "#{command(:mysql)} -uroot -ppassword mysql -NBe 'show databases'"
		execpipe(cmd) do |process|
			process.each do |line|
				if line.chomp.eql?(@resource[:name])
					result[:ensure] = :present
				end
			end
		end
		result
	end

	def create
		mysqladmin "create", @resource[:name], *@resource[:args]
	end
	def destroy
		mysqladmin "-f", "drop", @resource[:name]
	end

	def exists?
		mysql("-uuser", "-ppassword", "mysql", "-NBe", "show databases").match(/^#{@resource[:name]}$/)
	end
end

