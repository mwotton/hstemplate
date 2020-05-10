-- Deploy hstemplate:foos to pg
-- requires: appschema

BEGIN;

create table hstemplate.foos (
        id serial primary key,
	name text not null
);

COMMIT;
