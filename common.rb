def assert &code
  if not code.call
    src = code.source_location
    raise "Assertion failed in #{src[0]} at line #{src[1]}."
  end
end