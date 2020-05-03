# Convert various representations of 'yes' and 'no' to 'yes' and 'no'.
Puppet::Functions.create_function(:'bacula::yesno2str') do
  # @param value A boolean value
  # @return [String] Either 'yes' or 'no'
  # @example
  #   bacula::yesno2str(true)    #=> 'yes'
  #   bacula::yesno2str('true')  #=> 'yes'
  #   bacula::yesno2str('yes')   #=> 'yes'
  #   bacula::yesno2str(false)   #=> 'no'
  #   bacula::yesno2str('false') #=> 'no'
  #   bacula::yesno2str('no')    #=> 'no'
  dispatch :yesno2str do
    param 'Variant[Boolean, Enum["yes", "true", "no", "false"]]', :value
    return_type 'String'
  end

  def yesno2str(value)
    case value
    when true, 'true', 'yes' then 'yes'
    when false, 'false', 'no' then 'no'
    else raise "Unexpected value #{value}"
    end
  end
end
