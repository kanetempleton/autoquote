Before do
  # Runs before every scenario
  # Good place for future setup (clear data, etc.)
end

After do |scenario|
  # Runs after every scenario
  if scenario.failed?
    # Future: take screenshot, log extra info, etc.
  end
end
