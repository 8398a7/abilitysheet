# [IIDX☆12 参考表システム](https://sp12.iidx.app)

## Status

<p align="left">
  <a href="https://github.com/8398a7/abilitysheet"><img alt="GitHub Actions status" src="https://github.com/8398a7/abilitysheet/workflows/CI/badge.svg"></a>
</p>

[![Circle CI](https://circleci.com/gh/8398a7/abilitysheet.svg?style=shield)](https://circleci.com/gh/8398a7/abilitysheet)
[![Code Climate](https://codeclimate.com/github/8398a7/abilitysheet/badges/gpa.svg)](https://codeclimate.com/github/8398a7/abilitysheet)
[![Test Coverage](https://codeclimate.com/github/8398a7/abilitysheet/badges/coverage.svg)](https://codeclimate.com/github/8398a7/abilitysheet)
[![Issue Count](https://codeclimate.com/github/8398a7/abilitysheet/badges/issue_count.svg)](https://codeclimate.com/github/8398a7/abilitysheet)
[![security](https://hakiri.io/github/8398a7/abilitysheet/master.svg)](https://hakiri.io/github/8398a7/abilitysheet/master)
[![License](https://img.shields.io/github/license/8398a7/abilitysheet.svg)](https://github.com/8398a7/abilitysheet/blob/master/LICENSE.txt)

## Join to Development

### [共同開発者随時募集中](http://twitter.com/IIDX_12)

お気軽にツイッターや Discord で声をかけて下さい、とても喜びます。

[Discord](https://discord.gg/6pkkBgx)

![](https://cloud.githubusercontent.com/assets/8043276/14033422/789679c2-f25d-11e5-923a-a6b24d459a48.png)

## Domain Model

![](https://raw.githubusercontent.com/8398a7/abilitysheet/master/docs/erd.png)

## About

IIDX の SP☆12 の参考表をシステム化したものです。

- 現状と問題
  - 個人個人で管理している(エクセルやら HTML やら)
  - 作成や管理に手間がかかる、利便性に欠ける
- 提案システム
  - システムで一括管理
  - グラフ化やログの蓄積などを行い、データの可視化や記録ができる
  - Version ごとにログを取るため、過去のバージョンとの比較も行える

現在はネット上からノマゲ地力表、ハード地力表の反映。  
また、[iidx.me](https://iidx.me)から集計したデータを元に[項目応答理論](https://ja.wikipedia.org/wiki/%E9%A0%85%E7%9B%AE%E5%BF%9C%E7%AD%94%E7%90%86%E8%AB%96)を使い、[地力値表](https://sp12.iidx.app/recommends)を提供しています。

参考表は GCP 上の GKE にデプロイされ動作しています。  
master にマージされると deploy リソースを管理しているプライベートリポジトリに通知が行われ、デプロイが開始されます。

## Next

- プレイヤーの地力値推定、及び楽曲推薦
- スコアや BP の遷移グラフ

## [Requirements](https://github.com/8398a7/abilitysheet/wiki/Requirements)

## Setting

```sh
git clone https://github.com/8398a7/abilitysheet.git
cd abilitysheet
bundle install -j4 --path vendor/bundle
rails db:setup
rails s
```

## Database

PostgreSQL を採用しています。  
MySQL を使わなかった理由については[issue#130](https://github.com/8398a7/abilitysheet/issues/130)を参照ください。

## License

This software is released under the MIT License, see LICENSE.txt.
