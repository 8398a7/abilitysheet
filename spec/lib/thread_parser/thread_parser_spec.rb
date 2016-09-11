# frozen_string_literal: true
describe 'lib/thread_parser.rb' do
  let(:mock_root) { "#{Rails.root}/spec/mock/thread_parser" }
  let(:sheets) { JSON.parse(File.read("#{mock_root}/sheets.json")) }
  let(:n_query) { JSON.parse(File.read("#{mock_root}/thread.json"))['normal'] }
  let(:h_query) { JSON.parse(File.read("#{mock_root}/thread.json"))['hard'] }
  before do
    Sheet.import(sheets.map { |s| Sheet.new(s) })
  end

  it 'ノマゲ表のチェックができる' do
    expected = {}
    expect(ThreadParser.new(n_query, 'n_ability').run).to eq expected
  end

  it 'ハード表のチェックができる' do
    expected = {}
    expect(ThreadParser.new(h_query, 'h_ability').run).to eq expected
  end

  it 'ノマゲ表の差分が確認できる' do
    expected = 103
    expect(ThreadParser.new(h_query, 'n_ability').run.size).to eq expected
  end

  it 'ハード表の差分が確認できる' do
    expected = 102
    expect(ThreadParser.new(n_query, 'h_ability').run.size).to eq expected
  end
end
