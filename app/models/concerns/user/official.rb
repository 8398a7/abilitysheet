# frozen_string_literal: true
module User::Official
  extend ActiveSupport::Concern

  included do
    def update_official(params)
      data = params[:scores].tr("\r", "\n").split("\n").map do |line|
        line.split(',')
      end
      header = data.shift
      grade = User::Static::GRADE.index(params[:user][:grade])
      raise '[Official Update] No Grade' unless grade
      image = StringFileIO.create_from_canvas_base64(params[:user][:image])
      update!(grade: grade, djname: params[:user][:djname], image: image)

      update_official_part_score(header, data)
      true
    end

    def update_official_part_score(header, data)
      sheet_titles = Sheet.active.pluck(:title)
      has_hyper = ['gigadelic', 'Innocent Walls']
      hyper_map = {
        'HYPER' => '[H]',
        'ANOTHER' => '[A]'
      }
      white_list = {
        '旋律のドグマ～Miserables～' => '旋律のドグマ ～Misérables～',
        'Close the World feat. a☆ru' => 'Close the World feat.a☆ru',
        '火影' => '焱影'
      }
      data.each do |elem|
        hash = generate_hash_for_official_update(elem, header)

        if has_hyper.include?(hash['タイトル'])
          hyper_map.each do |key, value|
            title = hash['タイトル'] + value
            official_params = generate_official_params(hash, key)
            update_official_with_params(official_params, title)
          end
          next
        elsif white_list.keys.include?(hash['タイトル'])
          hash['タイトル'] = white_list[hash['タイトル']]
        elsif sheet_titles.include?(hash['タイトル'])
        else
          next
        end
        title = hash['タイトル']
        official_params = generate_official_params(hash, 'ANOTHER')
        update_official_with_params(official_params, title)
        sheet_titles.delete(hash['タイトル'])
      end
      true
    end

    def generate_hash_for_official_update(elem, header)
      hash = {}
      elem.each_with_index do |e, i|
        hash[header[i]] = e
      end
      hash
    end

    def generate_official_params(hash, key)
      official_params = {}
      official_params[:state] = ::Static::LAMP_OFFICIAL.index(hash["#{key} クリアタイプ"])
      official_params[:score] = hash["#{key} EXスコア"].to_i
      official_params[:bp] = hash["#{key} ミスカウント"].to_i
      official_params[:updated_at] = DateTime.parse(hash['最終プレー日時'])
      official_params
    end

    def update_official_with_params(official_params, title)
      sheet = Sheet.find_by!(title: title)
      official_params[:sheet_id] = sheet.id
      score = scores.find_or_create_by(sheet_id: sheet.id, version: Abilitysheet::Application.config.iidx_version)
      return if official_params[:state] == 7
      score.update_with_logs(official_params)
    end
  end
end
