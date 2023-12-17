-- 2022-10-26T17:30:00.000-04:00
alter table upload_types
  add column `last_upload` varchar(32);

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'dashboard:indicators:chart',
    '',
    null,
    '{"custom": "dashboard:indicators:chart"}'
  );
