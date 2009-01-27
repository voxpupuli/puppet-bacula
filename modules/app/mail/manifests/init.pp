# ensures email aliases
include mail
class mail {
    #
    # Some standard mail aliases
    #
    mailalias   { "root":
        ensure      => present,
        recipient   => "notify@infra.backcountry.com",
        target      => "/etc/aliases",
        notify      => Exec["rebuild-aliases"],
    }
    #
    # Rebuild Aliases
    #
    exec        { "rebuild-aliases":
        path        => "/usr/bin",
        command     => "newaliases",
        refreshonly => true,
    }
}
