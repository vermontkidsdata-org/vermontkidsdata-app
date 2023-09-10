update `queries`
  set `metadata`='{"server":{"transforms":{"Chart_url":[{"op":"mapurl"}]}}}'
  where `name`='dashboard:indicators:table';
