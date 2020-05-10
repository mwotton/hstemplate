-- Revert hstemplate:foos from pg

BEGIN;

drop table hstemplate.foos;

COMMIT;
