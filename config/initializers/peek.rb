Peek.into Peek::Views::PerformanceBar
Peek.into Peek::Views::Rblineprof
if Rails.env.development?
  Peek.into Peek::Views::GC
  Peek.into Peek::Views::Git, nwo: '8398a7/abilitysheet'
  Peek.into Peek::Views::PG
end
