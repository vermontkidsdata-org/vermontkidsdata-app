update upload_types
set column_map = '{"map": {"value_w": "School Value", "value_w_st":"State Value", "value_w_susd":"Supervisory Union Value"}}'
where type='general:assessments';

update upload_types
set column_map = '{"preserve": ["wp_id", "Chart_url", "link", "title"]}'
where type='dashboard:indicators';