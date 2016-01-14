module Static
  LAMP = %w(FC EXH H C E A F N).freeze

  LAMP_HASH = LAMP.map.with_index(0) { |e, i| [e, i] }.to_h

  POWER = [
    ['地力S+', 0],
    ['個人差S+', 1],
    ['地力S', 2],
    ['個人差S', 3],
    ['地力A+', 4],
    ['個人差A+', 5],
    ['地力A', 6],
    ['個人差A', 7],
    ['地力B+', 8],
    ['個人差B+', 9],
    ['地力B', 10],
    ['個人差B', 11],
    ['地力C', 12],
    ['個人差C', 13],
    ['地力D', 14],
    ['個人差D', 15],
    ['地力E', 16],
    ['個人差E', 17],
    ['地力F', 18],
    ['難易度未定', 19]
  ].freeze

  VERSION = [
    ['5',    5],
    ['6',    6],
    ['7',    7],
    ['8',    8],
    ['9',    9],
    ['10',   10],
    ['RED',  11],
    ['HS',   12],
    ['DD',   13],
    ['GOLD', 14],
    ['DJT',  15],
    ['EMP',  16],
    ['SIR',  17],
    ['RA',   18],
    ['Lin',  19],
    ['tri',  20],
    ['SPD',  21],
    ['PEN',  22],
    ['COP',  23]
  ].freeze

  COLOR = %w(
    #ff8c00
    #ffd900
    #ff6347
    #afeeee
    #98fb98
    #9595ff
    #c0c0c0
    #ffffff
  ).freeze
end
