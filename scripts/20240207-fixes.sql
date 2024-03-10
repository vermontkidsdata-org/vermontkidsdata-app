delete from queries where name='pmads:chart';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'pmads:chart',
    'SELECT `category` as `cat`, geography as `label`, `value`*100 as `value` FROM data_pmads where `category`="prevalence" order by `year`',
    'general:pmads',
    '{"yAxis": {"type": "percent"}}'
  );

delete from queries where name='coordinated_entry_services:chart';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'coordinated_entry_services:chart',
    'SELECT `age` as `cat`, geography as `label`, `value` FROM data_coordinated_entry_services where geography="Vermont" order by `year`, FIELD(`cat`,"Under 5","5-12","13-17","Under 18")',
    'general:coordinated_entry_services',
    '{"yAxis": {"type": "number"}}'
  );

-- https://ui.vtkidsdata.org/columnchart/preventative_dental:chart
delete from queries where name='preventative_dental:chart';

insert into
  queries (name, sqlText, uploadType, metadata) value (
    'preventative_dental:chart',
    'SELECT `year` as cat, "Vermont" as label, `percent`*100 as `value` FROM `data_preventative_dental` where geo_type="State" and geography="Vermont" order by `year`',
    'general:preventative_dental',
    '{"yAxis": {"type": "percent"}}'
  );
