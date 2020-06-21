-- Deploy hstemplate:index_name to pg

BEGIN;

create index foos_name_index on hstemplate.foos(name);

COMMIT;
