Facter.add("systemid") do
  confine :kernel => "Darwin"

  setcode do
    lastuser      = Facter.value('lastuser')
    model         = Facter.value('sp_machine_name').downcase.sub(",", "").sub(" ","")
    hostname      = Facter.value('hostname')
    uuid          = Facter.value('sp_platform_uuid')

    # do some fixup pon the machine_name
    model.sub!(/macbookpro/, 'mbp')
    model.sub!(/macmini/, 'mini')
    model.sub!(/macbookair/, 'air')
    model.sub!(/imac/, 'imac')

    #"#{lastuser}-#{hostname}-#{model}-#{uuid}"
    "#{model}-#{uuid}"
  end
end
