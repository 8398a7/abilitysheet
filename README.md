# [IIDX☆12参考表システム](https://iidx12.tk)

## Status

[![Circle CI](https://circleci.com/gh/8398a7/abilitysheet.svg?style=shield)](https://circleci.com/gh/8398a7/abilitysheet)
[![Code Climate](https://codeclimate.com/github/8398a7/abilitysheet/badges/gpa.svg)](https://codeclimate.com/github/8398a7/abilitysheet)
[![Test Coverage](https://codeclimate.com/github/8398a7/abilitysheet/badges/coverage.svg)](https://codeclimate.com/github/8398a7/abilitysheet)
[![Issue Count](https://codeclimate.com/github/8398a7/abilitysheet/badges/issue_count.svg)](https://codeclimate.com/github/8398a7/abilitysheet)
[![security](https://hakiri.io/github/8398a7/abilitysheet/master.svg)](https://hakiri.io/github/8398a7/abilitysheet/master)
[![Dependency Status](https://gemnasium.com/8398a7/abilitysheet.svg)](https://gemnasium.com/8398a7/abilitysheet)
[![Release](https://img.shields.io/github/release/8398a7/abilitysheet.svg)](https://github.com/8398a7/abilitysheet/releases/latest)
[![License](https://img.shields.io/github/license/8398a7/abilitysheet.svg)](https://github.com/8398a7/abilitysheet/blob/master/LICENSE.txt)

![](https://cloud.githubusercontent.com/assets/8043276/14033422/789679c2-f25d-11e5-923a-a6b24d459a48.png)

## About

IIDXのSP☆12の参考表をシステム化したものです．

* 現状と問題
  * 個人個人で管理している(エクセルやらHTMLやら)
  * 作成や管理に手間がかかる，利便性に欠ける

* 提案システム
  * システムで一括管理
  * グラフ化やログの蓄積などを行い，データの可視化や記録ができる
  * Versionごとにログを取るため，過去のバージョンとの比較も行える

現在はネット上からノマゲ地力表，ハード地力表の反映．  
また，[iidx.me](http://iidx.me)から集計したデータを元に[項目応答理論](http://ja.wikipedia.org/wiki/%E9%A0%85%E7%9B%AE%E5%BF%9C%E7%AD%94%E7%90%86%E8%AB%96)を使い，[地力値表](https://iidx12.tk/abilitysheet/recommends/list)を提供しています．

## Next

* プレイヤーの地力値推定，及び楽曲推薦
* スコアやBPの遷移グラフ

## Requires

- ruby 2.3.0
- rails 4.2.6
- node 5.9.0
- npm 3.7.3
- bower 1.7.7

## Setting

```sh
git clone https://github.com/8398a7/abilitysheet.git
cd abilitysheet
bundle install -j4 --path vendor/bundle
rake db:setup
rails s
```

## Help

### [共同開発者随時募集中](http://twitter.com/IIDX_12)
[![Join the chat at https://gitter.im/8398a7/abilitysheet](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/8398a7/abilitysheet?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  
お気軽にツイッターやgitterで声をかけて下さい，とても喜びます．

## Database

PostgreSQLを採用しています．  
MySQLを使わなかった理由については[issue#130](https://github.com/8398a7/abilitysheet/issues/130)を参照ください．

## License

This software is released under the MIT License, see LICENSE.txt.
