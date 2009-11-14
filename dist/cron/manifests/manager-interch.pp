# class to handle interch user crontab
# arbitrary cron names must be GLOBALLY unique
class cron::manager-interch inherits cron {
    Cron    { 
        user            => interch,
    }
    cron    {
        "sac-forum-post":
            command     => "test -f /etc/bc-is-master && bin/odat_sold_out_post.pl",
            ensure      => present;
        "send-transactional-email":
            command     => "test -f /etc/bc-is-master && bin/send_transactional_emails.pl",
            ensure      => present;
        "home-dash-update":
            command     => "test -f /etc/bc-is-master && bin/home_dashboard.pl",
            ensure      => present,
            minute      => 5;
        "merch-dash-update":
            command     => "test -f /etc/bc-is-master && bin/merchandising_dashboard.pl",
            ensure      => present,
            minute      => 7;
        "rebuild-picklist":
            command     => "test -f /etc/bc-is-master && bin/prepare-picklists",
            ensure      => present,
            minute      => "*/10";
        "issue-ea-POs":
            environment => [ "ETL_OP_ENV=prod", "LOGF=/var/log/interchange/prepare-ea_purchase_orders.log" ],
            command     => "test -f /etc/bc-is-master && (sleep 45; date >> \$LOGF; bin/prepare-ea_purchase_orders >> \$LOGF 2>&1)",
            ensure      => present,
            minute      => "*/10";
        "tote-routing":
            command     => "test -f /etc/bc-is-master && bin/empty_tote_routing.pl",
            ensure      => present,
            minute      => "*/4";
        "tote-maintenance":
            command     => "test -f /etc/bc-is-master && bin/tote_maintenance.pl",
            ensure      => present,
            minute      => 45,
            hour        => "*/2";
        "get-ups-exception":
            command     => "test -f /etc/bc-is-master && bin/get_ups_exceptions.pl",
            ensure      => present,
            minute      => 35,
            hour        => "*/2";
        "generate-goals-page":
            command     => "test -f /etc/bc-is-master && bin/generate_goals_page.pl",
            ensure      => present,
            minute      => 1;
        "image-management":
            command     => "test -f /etc/bc-is-master && bin/img_outsource_process_images.pl",
            ensure      => present,
            minute      => "*/20";
        "purge-ic-work":
            command     => "test -f /etc/bc-is-master && nice bin/purge-ic-work-files 2>/dev/null",
            ensure      => present,
            minute      => 25,
            hour        => "*/3";
        "cancel-test-orders":
            command     => "test -f /etc/bc-is-master && bin/gomez_cancel_test_orders.pl",
            ensure      => present,
            minute      => 40;
        "ups-closeout1":
            command     => "test -f /etc/bc-is-master && bin/ups_closeout.pl",
            ensure      => present,
            minute      => 0,
            hour        => [ "16-19", 23 ];
        "ups-closeout2":
            command     => "test -f /etc/bc-is-master && bin/ups_closeout.pl",
            ensure      => present,
            minute      => 30,
            hour        => 19;
        "sac-first-post":
            command     => "test -f /etc/bc-is-master && bin/odat_first_post.pl",
            ensure      => present,
            minute      => 0,
            hour        => 0;
        "spa-bot":
            command     => "test -f /etc/bc-is-master && bin/spa_bot.pl",
            ensure      => present,
            minute      => 6,
            hour        => 0;
        "spa-revert-bot":
            command     => "test -f /etc/bc-is-master && bin/spa_revert_bot.pl",
            ensure      => present,
            minute      => 10,
            hour        => 0;
        "cat-assignments":
            command     => "test -f /etc/bc-is-master && bin/cat_assignments.pl",
            ensure      => present,
            minute      => 14,
            hour        => 0;
        "customer-score":
            command     => "test -f /etc/bc-is-master && bin/customer-score >/dev/null 2>&1",
            ensure      => present,
            minute      => 30,
            hour        => 0;
        "purge-print":
            command     => "test -f /etc/bc-is-master && (nice find /var/www/html/print -type f -daystart -mtime +0 -print0 | xargs -0 -r -n 10 rm -f)",
            ensure      => present,
            minute      => 12,
            hour        => 1;
        "purge-download":
            command     => "test -f /etc/bc-is-master && (nice find /var/www/html/download -type f -daystart -mtime +1 -a \! -path '*/kwms*' -print0 | xargs -0 -r rm -f)",
            ensure      => present,
            minute      => 17,
            hour        => 1;
        "purge-graphs":
            command     => "test -f /etc/bc-is-master && (nice find /var/www/html/foundation/graphs -type f -daystart -mtime +1 -print0 | xargs -0 -r rm -f)",
            ensure      => present,
            minute      => 20,
            hour        => 1;
        "dash-table-insert":
            command     => "test -f /etc/bc-is-master && bin/dashboard_table_inserts.pl",
            ensure      => present,
            minute      => 30,
            hour        => 1;
        "home-dashboard":
            command     => "test -f /etc/bc-is-master && bin/home_dashboard.pl 1",
            ensure      => present,
            minute      => 55,
            hour        => 1;
        "merch-dashboard":
            command     => "test -f /etc/bc-is-master && bin/merchandising_dashboard.pl 1",
            ensure      => present,
            minute      => 59,
            hour        => 1;
        "sales-margin-table":
            command     => "test -f /etc/bc-is-master && bin/sales_margin_table_insert.pl",
            ensure      => present,
            minute      => 5,
            hour        => 2;
        "push-everything-files":
            command     => "test -f /etc/bc-is-master && bin/push-everything-files",
            ensure      => present,
            minute      => 45,
            hour        => 1;
        "b2b-image-push":
            command     => "test -f /etc/bc-is-master && bin/push-product-images styx",
            ensure      => present,
            minute      => 10,
            hour        => 2;
        "push-everything-db":
            command     => "test -f /etc/bc-is-master && bin/push-everything-db",
            ensure      => present,
            minute      => 10,
            hour        => 3;
        "gen-sitemaps":
            command     => "test -f /etc/bc-is-master && bin/generate_sitemaps.sh",
            ensure      => present,
            minute      => 0,
            hour        => 4;
        "missing-images":
            command     => "test -f /etc/bc-is-master && bin/populate_missing_images.pl",
            ensure      => present,
            minute      => 50,
            hour        => 4;
        "item-images-basecamp":
            command     => "test -f /etc/bc-is-master && bin/push-product-images owen",
            ensure      => present,
            minute      => 30,
            hour        => 5;
        "promo-images-basecamp":
            command     => "test -f /etc/bc-is-master && bin/push-files --directories=/var/www/html/images/promo_upload/ owen",
            ensure      => present,
            minute      => 0, 
            hour        => 5;
        "keyword-landing":
            command     => "test -f /etc/bc-is-master && bin/keyword_landing_email.pl",
            ensure      => present,
            minute      => 0,
            hour        => 6;
        "inactivate-ic-access":
            command     => "test -f /etc/bc-is-master && bin/inactivate_ic_access.pl",
            ensure      => present,
            minute      => 30,
            hour        => 6;
        "tnf-price-report":
            command     => "test -f /etc/bc-is-master && bin/tnf_price_range_report.pl",
            ensure      => present,
            minute      => 0,
            hour        => 7;
        "google-sitemap-count":
            command     => "test -f /etc/bc-is-master && bin/email_google_sitemap_counts.pl --to=seo@backcountry.com --dir=/var/www/html/",
            ensure      => present,
            minute      => 0,
            hour        => 7,
            weekday     => 1;
        "package-check":
            command     => "test -f /etc/bc-is-master && bin/package_check.pl",
            ensure      => present,
            minute      => 20,
            hour        => 7,
            weekday     => "1-5";
        "create-coupons":
            command     => "test -f /etc/bc-is-master && bin/create_coupons.pl",
            ensure      => present,
            minute      => 43,
            hour        => [ 11, 16 ];
        "pull-image-uploads":
            command     => "test -f /etc/bc-is-master && bin/pull-image-uploads",
            ensure      => present,
            minute      => 0,
            hour        => 15;
        "exchange-rates":
            command     => "test -f /etc/bc-is-master && bin/exchange_rates.pl",
            ensure      => present,
            minute      => 30,
            hour        => 9;
        "update-ups-stats":
            command     => "test -f /etc/bc-is-master && bin/update_ups_stats.pl",
            ensure      => present,
            minute      => 0,
            hour        => 22;
        "push-feeds-info":
            command     => "test -f /etc/bc-is-master && bin/push-feeds-info.new",
            ensure      => present,
            minute      => 0,
            hour        => 22;
        "build-404":
            command     => "test -f /etc/bc-is-master && /var/lib/interchange/bin/build_404",
            ensure      => present,
            minute      => 0,
            hour        => 23;
        "groups-sales-order":
            command     => "test -f /etc/bc-is-master && bin/gso_po.pl",
            ensure      => present,
            minute      => 30,
            hour        => 23;
        "top-ten-ic":
            command     => "test -f /etc/bc-is-master && bin/daily_top_ten_ic_pages",
            ensure      => present,
            minute      => 50,
            hour        => 23;
        "gen-bug-stats":
            command     => "test -f /etc/bc-is-master && bin/run_bug_actions.sh",
            ensure      => present,
            minute      => 30,
            hour        => 4,
            weekday     => 0;
        "make-sprites":
            command     => "test -f /etc/bc-is-master && bin/make_sprites.pl",
            ensure      => present,
            minute      => 0,
            hour        => 21;
        "market-dash":
            command     => "test -f /etc/bc-is-master && bin/marketing_dashboard.pl",
            ensure      => present,
            minute      => 15,
            hour        => 1,
            monthday    => 1;
    }
}
