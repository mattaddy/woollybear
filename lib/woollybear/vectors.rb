module WoollyBear
  VECTORS = {
    :xss           => '>"><script>alert("XSS")</script>&',
    :int_overflow  => 1.to_s * 1000,
    :sql_injection => "' ; drop table temp --"
  }
end
