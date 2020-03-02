every 3.hours do
  rake "event:extract", output: 'log/whenever.log'
end
