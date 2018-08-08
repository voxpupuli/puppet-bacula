Puppet::Functions.create_function(:'bacula::escape') do
  dispatch :escape do
    param 'String', :value
    return_type 'String'
  end

  def escape(value)
    value.inspect
  end
end
