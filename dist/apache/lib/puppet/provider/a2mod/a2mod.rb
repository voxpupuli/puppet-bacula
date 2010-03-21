Puppet::Type.type(:a2mod).provide(:a2mod) do
    desc "Manage Apache 2 modules on Debian and Ubuntu"
 
    commands :encmd => "a2enmod"
    commands :discmd => "a2dismod"
 
    defaultfor :operatingsystem => [:debian, :ubuntu]

    def create
        encmd resource[:name]
    end
 
    def destroy
        discmd resource[:name]
    end
 
    def exists?
        output = encmd, resource[:name]
        if output =~ /already enabled/
            return :true
        else
            return :false
        end
    end
end
