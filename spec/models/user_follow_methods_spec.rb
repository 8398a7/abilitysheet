# frozen_string_literal: true

# == Schema Information
#
# Table name: follows
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  target_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

describe User::FollowMethods, type: :model do
  describe '#follow' do
    before do
      (1..12).each do |i|
        create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i))
      end
    end

    context 'ライバル機能を使っていないユーザ同士' do
      let(:user) { User.find_by(id: 1) }
      let(:target) { User.find_by(id: 2) }
      context 'ライバルに登録' do
        before { user.follow(target.iidxid) }
        it '自身のライバルに追加されている' do
          expect(user.following).to include(target)
        end
        it '相手の逆ライバルに追加されている' do
          target.reload
          expect(target.followers).to include(user)
        end
      end
      describe '既にライバル登録済みのユーザをライバルにしようとする' do
        before { user.follow(target.iidxid) }
        it 'falseを返す' do
          expect(user.follow(target.iidxid)).to eq false
        end
        it 'ライバル数，逆ライバル数は1のままである' do
          target.reload
          expect(user.following.count).to eq 1
          expect(target.followers.count).to eq 1
        end
      end
    end

    context '自身がライバルの機能を使っていて，相手は使っていない' do
      let(:user) { User.find_by(id: 1) }
      let(:target) { User.find_by(id: 2) }
      let(:sub) { User.find_by(id: 3) }
      before do
        user.follow(sub.iidxid)
        user.follow(target.iidxid)
      end
      it '自身のライバルに追加されている' do
        expect(user.following).to include(target)
      end
      it '相手の逆ライバルに追加されている' do
        target.reload
        expect(target.followers).to include(user)
      end
    end
  end

  describe '#unfollow' do
    before do
      (1..12).each { |i| create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i)) }
    end
    let(:user) { User.find_by(id: 1) }
    let(:target) { User.find_by(id: 2) }
    describe 'ライバルに登録し，削除する' do
      before do
        user.follow(target.iidxid)
        user.unfollow(target.iidxid)
      end
      it 'ユーザのライバルは0である' do
        expect(user.following.count).to eq 0
      end
      it 'ターゲットの逆ライバルは0である' do
        target.reload
        expect(target.followers.count).to eq 0
      end
    end
    describe '登録していないユーザを削除しようとする' do
      it 'falseを返す' do
        expect(user.unfollow(target.iidxid)).to eq false
      end
      it 'ユーザのライバルは0である' do
        expect(user.following.count).to eq 0
      end
      it 'ターゲットの逆ライバルは0である' do
        target.reload
        expect(target.followers.count).to eq 0
      end
    end
  end

  describe '#following?' do
    before do
      (1..2).each { |i| create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i)) }
    end
    it 'フォローしていればtrueを返す' do
      User.find(1).follow(User.find(2).iidxid)
      expect(User.find(1).following?(2)).to eq true
    end
    it 'フォローしていればいなければfalseを返す' do
      expect(User.find(1).following?(2)).to eq false
    end
  end

  describe '#change_follow' do
    before do
      (1..2).each { |i| create(:user, id: i, iidxid: format('0000-%04d', i), username: format('test%d', i)) }
    end
    it 'フォローしていればアンフォローする' do
      User.find(1).follow(User.find(2).iidxid)
      User.find(1).change_follow(User.find(2))
      expect(User.find(1).following?(2)).to eq false
    end
    it 'フォローしていなければフォローする' do
      User.find(1).unfollow(User.find(2).iidxid)
      User.find(1).change_follow(User.find(2))
      expect(User.find(1).following?(2)).to eq true
    end
  end
end
