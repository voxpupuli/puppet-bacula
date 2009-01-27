CREATE OR REPLACE FUNCTION analyze_unloved_tables()
RETURNS TEXT
LANGUAGE plpgsql
AS $_$
DECLARE myrec RECORD; total INTEGER = 0; myst TEXT;
BEGIN
  FOR myrec IN SELECT quote_ident(nspname)||'.'||quote_ident(relname) AS t
    FROM pg_catalog.pg_class c, pg_catalog.pg_namespace n
    WHERE c.relnamespace = n.oid
    AND c.relkind = 'r'
    AND c.reltuples = 0
    AND c.relpages = 0
  LOOP
    total = total + 1;
    myst = 'ANALYZE VERBOSE '||myrec.t;
    RAISE DEBUG '%', myst;
    EXECUTE myst;
  END LOOP;
  RETURN 'Tables analyzed: '||total;
END;
$_$;

SELECT analyze_unloved_tables();


