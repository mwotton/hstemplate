-- Verify hstemplate:foos on pg

BEGIN;

select name from hstemplate.foos where false;

ROLLBACK;
