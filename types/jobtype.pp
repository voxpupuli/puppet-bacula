type Bacula::JobType = Pattern[
  /^Backup/,
  /^Restore/,
  /^Admin/,
  /^Verify/,
  /^Copy/,
  /^Migrate/,
]
