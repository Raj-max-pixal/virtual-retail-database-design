# Scheduling the SQL automation

PostgreSQL does not include a universal built-in cron scheduler in every installation. Choose one supported method in your environment.

## Option A — pg_cron extension
If your PostgreSQL service supports and permits `pg_cron`, ask the database administrator to enable it. Then, for example:

```sql
-- Example only; extension setup permissions vary by host.
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Run at 02:15 every day. This invokes the archive procedure with a fixed cutoff.
-- Review and update the retention cutoff policy before using in production.
SELECT cron.schedule(
  'archive-completed-orders',
  '15 2 * * *',
  $$CALL archive_completed_orders(TIMESTAMP '2025-01-01 00:00:00');$$
);
```

The fixed cutoff above is only an example and will become stale. A production design should compute a rolling cutoff through a carefully reviewed function or orchestration job.

## Option B — Operating-system scheduler
Use cron on Linux or Task Scheduler on Windows to invoke `psql` with a secured connection configuration. Avoid placing passwords directly in scripts or command history. Use a restricted database account and a protected `.pgpass` file or another approved secret mechanism.

Example Linux cron entry (adapt paths and connection settings):
```cron
15 2 * * * /usr/bin/psql -X -v ON_ERROR_STOP=1 -d retail_db -c "CALL archive_completed_orders(TIMESTAMP '2025-01-01 00:00:00');" >> /var/log/retail-archive.log 2>&1
```

This is a demonstration command, not a complete production rolling-retention implementation. Test manually first, monitor exit status, and rotate logs.
