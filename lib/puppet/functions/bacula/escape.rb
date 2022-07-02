# frozen_string_literal: true

# Return a quoted escaped string suitable for bacula configuration
Puppet::Functions.create_function(:'bacula::escape') do
  # @param value The string to escape
  # @return [String] The escaped string
  # @example
  #   bacula::escape('sed -i "" -e s|a|b| /tmp/tmp.U6BF0NIS') #=> "\"sed -i \\\"\\\" -e s|a|b| /tmp/tmp.U6BF0NIS\""
  dispatch :escape do
    param 'String', :value
    return_type 'String'
  end

  def escape(value)
    value.inspect
  end
end
