class SheetWorker
  include Sidekiq::Worker
  sidekiq_options queue: :sheet
  sidekiq_options retry: false

  def perform(id)
    puts %(#{Time.now} sheet_id: #{id} => create score and ability start)

    version = Abilitysheet::Application.config.iidx_version
    User.all.each do |u|
      next if Score.exists?(user_id: u.id, sheet_id: id, version: version)
      Score.create(user_id: u.id, sheet_id: id, version: version)
    end

    d = 99.99
    Ability.create(
      sheet_id: id,
      fc: d, exh: d, h: d, c: d, e: d, aaa: d
    )
    puts %(#{Time.now} sheet_id: #{id} => create score and ability end)
  end
end
