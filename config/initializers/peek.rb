def get_revision
  return '' if Rails.env.development? || Rails.env.test?
  path = Rails.root.to_s.split('/')
  version = path.pop
  path.pop
  revisions = path.join('/') + '/revisions.log'
  revision = nil
  File.read(revisions).split("\n").each do |line|
    next unless line.include?(version)
    revision = line.match(/[a-z0-9]{7}/)[0]
  end
  revision
rescue
  return ''
end

Peek.into Peek::Views::GC
if Rails.env.production?
  Peek.into Peek::Views::Git, nwo: '8398a7/abilitysheet', branch_name: 'master', protocol: 'https', domain: 'github.com', sha: get_revision
else
  Peek.into Peek::Views::Git, nwo: '8398a7/abilitysheet'
end
Peek.into Peek::Views::Host
Peek.into Peek::Views::PerformanceBar
Peek.into Peek::Views::PG
Peek.into Peek::Views::Rblineprof
Peek.into Peek::Views::Redis
Peek.into Peek::Views::Sidekiq
