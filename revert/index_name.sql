-- Revert hstemplate:index_name from pg

BEGIN;

drop index foos_name_index;

COMMIT;
