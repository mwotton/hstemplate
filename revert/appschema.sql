-- Revert hstemplate:appschema from pg

BEGIN;

drop schema hstemplate;

COMMIT;
