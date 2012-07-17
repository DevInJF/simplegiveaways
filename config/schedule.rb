every 1.hour do
  runner "RefreshWorker.perform_async"
end