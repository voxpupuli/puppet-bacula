Puppet::Functions.create_function(:'bacula::yesno2str') do
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
