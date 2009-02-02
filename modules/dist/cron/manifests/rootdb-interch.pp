# class to handle interch user crontab
# arbitrary cron names must be GLOBALLY unique
class cron::rootdb-interch inherits cron {
    Cron    { 
        environment => "PGHOST=/db/rootdb/sockets",
        user        => interch,
    }
    cron    {
        "move-suspend":
            command     => "test -d /db/rootdb/db/data && bin/move-suspend --bcs",
            ensure      => present,
            minute      => '*/15';
        "orders-from-orders-shipped":
            command     => "test -d /db/rootdb/db/data && bin/update_orders_from_orders_ups_shipped_queue.pl",
            ensure      => present,
            minute      => '*/10';
        "replenishment":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/suspense_replenishment_lists.sql",
            ensure      => present,
            minute      => '*/20';
        "bang-saved":
            command     => "test -d /db/rootdb/db/data && bin/bang-saved",
            ensure      => present,
            minute      => '*/5';
        "ticket-flow":    
            command     => "test -d /db/rootdb/db/data && bin/ticket_flow.pl",
            ensure      => present,
            minute      => '*/5';
        "push-woot":
            command     => "test -d /db/rootdb/db/data && bin/push-woot | tee -a tmp/push-woot.log",
            ensure      => present,
            minute      => 50;
        "purge-order-locks":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/purge-order-locks.sql",
            ensure      => present,
            minute      => 1,
            hour        => '*/3';
        "onhand-snap":    
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/inventory_on_hand_snapshots_add.sql",
            ensure      => present,
            minute      => 56,
            hour        => 23;
        "update-collect-priority":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_collection_priority.sql",
            ensure      => present,
            minute      => 54,
            hour        => 23;
        "update-is-odat":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_is_odat.sql",
            ensure      => present,
            minute      => 52,
            hour        => 23;
        "rebuild-orders-shipping-snapshot":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/orders_shipping_snapshot_add.sql",
            ensure      => present,
            minute      => 0,
            hour        => 0,
            monthday    => 1;
        "push-download":
            command     => "test -d /db/rootdb/db/data && bin/push-download",
            ensure      => present,
            minute      => 4,
            hour        => 0;
        "push-inventory1":
            command     => "test -d /db/rootdb/db/data && bin/push-inventory | tee -a tmp/push-inventrory.log",
            ensure      => present,
            minute      => 5,
            hour        => 0;
        "push-inventory2":
            command     => "test -d /db/rootdb/db/data && bin/push-inventory | tee -a tmp/push-inventory.log",
            ensure      => present,
            minute      => 45,
            hour        => 1;
        "push-inventory3":
            command     => "test -d /db/rootdb/db/data && bin/push-inventory | tee -a tmp/push-inventory.log",
            ensure      => present,
            minute      => 0,
            hour        => [ 1, '6-23' ];
        "correct-po-status":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/correct_po_status.sql",
            ensure      => present,
            minute      => 5,
            hour        => 0;
        "inventory-asset-log":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/inventory_asset_log_add.sql",
            ensure      => present,
            minute      => 56,
            hour        => 23;
        "update-table-sales":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_table_sales_returns_by_month_report.sql",
            ensure      => present,
            minute      => 15,
            hour        => 0;
        "incomplete-purge":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/incomplete_purge.sql",
            ensure      => present,
            minute      => 21,
            hour        => 0;
        "rebuild-otb":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/rebuild_otb_history_data.sql",
            ensure      => present,
            minute      => 35,
            hour        => 0;
        "build-crunch-sales":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/build_crunch_sales_data.sql",
            ensure      => present,
            minute      => 45,
            hour        => 0;
        "push-best-sellers":
            command     => "test -d /db/rootdb/db/data && bin/push-best-sellers",
            ensure      => present,
            minute      => 0,
            hour        => 1;
        "email-tks-snap":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/email_tks_snapshot.sql",
            ensure      => present,
            minute      => 1,
            hour        => 1;
        "update-orders-by-rep":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_orders_by_rep_snapshot.sql",
            ensure      => present,
            minute      => 5,
            hour        => 1;
        "update-group-sales":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_group_sales_report_snapshot.sql",
            ensure      => present,
            minute      => 10,
            hour        => 1;
        "update-batch-summary":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_batch_summary_snanpshot.sql",
            ensure      => present,
            minute      => 0,
            hour        => 1,
            weekday     => 1;
        "rebuild-orders-summary":
            command     => "test -d /db/rootdb/db/data && bin/rebuild-orders-summary-snapshot",
            ensure      => present,
            minute      => 0,
            hour        => 0;
        "switch-inactive-subsku":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/switch_inactive_subskus_with_qoh.sql",
            ensure      => present,
            minute      => 0,
            hour        => 2;
        "make-price-snap":
            command     => "test -d /db/rootdb/db/data && bin/make-price-snapshot",
            ensure      => present,
            minute      => 59,
            hour        => 4;
        "clear-worksheet-lock":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/clear_worksheet_locks.sql",
            ensure      => present,
            minute      => 30,
            hour        => 5;
        "inventory-alert-email":
            command     => "test -d /db/rootdb/db/data && bin/inventory_alert_email.pl",
            ensure      => present,
            minute      => 45,
            hour        => 6;
        "hows-your-gear":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/hows-your-gear.sql",
            ensure      => present,
            minute      => 0,
            hour        => 10;
        "net-promoter":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/net_promoter.sql",
            ensure      => absent,
            minute      => 0,
            hour        => 10;
        "check-for-price-act":
            command     => "test -d /db/rootdb/db/data && bin/check-for-price-action-errors ",
            ensure      => present,
            minute      => 0,
            hour        => 18,
            weekday     => 0;
        "update-review-count":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_review_counts.sql",
            ensure      => present,
            minute      => 0,
            hour        => 20;
        "auto-activate":
            command     => "test -d /db/rootdb/db/data && bin/auto-activate.pl",
            ensure      => present,
            minute      => 30,
            hour        => 22;
        "inventory-track-purge":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/inventory_tracking_purge.sql",
            ensure      => present,
            minute      => 3,
            hour        => 23;
        "related-sales":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/related_sales.sql",
            ensure      => present,
            minute      => 59,
            hour        => 23;
        "gold-point-allocation":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/gold_point_allocation.sql",
            ensure      => present,
            minute      => 0,
            hour        => 2,
            monthday    => 1;
        "ar-gc-snapshot":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/ar_and_gc_snapshots_add.sql",
            ensure      => present,
            minute      => 0,
            hour        => 1,
            monthday    => 1;
        "update-inventory-inhouse":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_inventory_inhouse_snapshot.sql",
            ensure      => present,
            minute      => 0,
            hour        => 0,
            monthday    => 1;
        "content-writer-brand":
            command     => "test -d /db/rootdb/db/data && ~/bin/content_writers_brand_assign.pl",
            ensure      => present,
            minute      => 30,
            hour        => 7,
            weekday     => 'Sunday';
        "update-180-pastdue":
            command     => "test -d /db/rootdb/db/data && psql -U bcs bcs -f sql-cron/update_180_past_due.sql",
            ensure      => present,
            minute      => 0,
            hour        => 8,
            weekday     => 0;
        "touch-test":
            command     => "echo \$PGHOST >/tmp/touch-test.cron",
            ensure      => present;
    }
}
