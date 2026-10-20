# 依存ライブラリの脆弱性対応（2026-10-20）

`Gemfile.lock` を RubySec、`yarn.lock` を Yarn の公開 advisory データと照合して更新した。件数は実際の悪用可能性ではなく、依存バージョンに該当する報告数。

| 対象 | 更新前 | 更新後 |
| --- | ---: | ---: |
| Ruby（bundler-audit の検出件数） | 135 | 0 |
| JavaScript（GHSA の重複を除いた件数） | 198 | 42 |
| JavaScript（依存経路ごとの critical 件数） | 38 | 0 |

Rails 7.2.4、Devise 5.0.4、Rack 2.2.24、Puma 7.2.1、Nokogiri 1.19.4、Sidekiq 6.5.12、sidekiq-cron 2.4.0 などに更新した。使用箇所も依存元もなかった Sinatra は削除した。

Rails 7.2 に対応する Ransack と RSpec に更新し、管理画面の既存の検索・並び替えに必要な項目と関連のみを検索許可リストにした。Sentry の Ruby SDK は既存の初期化設定と互換性がある 5.5 系を維持した。

`webdrivers` の Selenium バージョン制限を取り除き、Selenium 4.51.0 と rubyzip 3.4 系へ更新した。ブラウザードライバーは Selenium 標準の管理機能を使う。削除した `webdrivers` 専用の SSL 検証回避も不要になった。

JavaScript は axios 0.34 系、Highcharts 9.3 系、Sentry 7.120 系、jQuery UI 1.14 系、Immutable 4.3 系と、既存の指定範囲内で更新可能な間接依存を更新した。`tar` と `serialize-javascript` は `resolutions` で修正版を指定した。Node.js 22 での本番アセット生成を検証した。

## 残っている依存関係

Yarn の最終結果は low 3、moderate 56、high 39、critical 0（依存経路ごとの集計）。次の 15 パッケージに 42 種類の advisory が残る。

| 主な依存元 | 残存パッケージ |
| --- | --- |
| webpack-dev-server 3 | webpack-dev-server、webpack-dev-middleware、http-proxy-middleware、node-forge、ip、uuid |
| Webpacker 5 / Webpack 4 のビルド・CSS 処理 | postcss、postcss-selector-parser、svgo、nth-check、micromatch、braces、elliptic、sprintf-js |
| query-string 5 および古いソースマップ処理 | decode-uri-component |

[Webpacker は開発終了済み](https://github.com/rails/webpacker#webpacker-has-been-retired-)で、5 系の JavaScript 依存は今後更新されない。たとえば [webpack-dev-server の修正](https://github.com/webpack/webpack-dev-server/security/advisories/GHSA-79cf-xcqc-c78w)には 5 系が必要だが、Webpack 5 と開発サーバー設定への移行を伴う。

残存報告の解消には、Webpacker から保守されているビルド環境への移行と、query-string の呼び出し元の更新が必要。`decode-uri-component` 0.5 を単独で強制すると CommonJS の呼び出し元が起動しなくなるため、強制指定していない。開発用・間接依存という理由で advisory を無視する設定は追加していない。

## 再確認

```sh
bundler-audit check --update
yarn audit --json
yarn install --frozen-lockfile
yarn lint
bundle exec bin/rubocop_parallel
bundle exec rspec
NODE_ENV=production RAILS_ENV=production bundle exec rails assets:precompile
```

`bundler-audit` は確認用の外部ツールとして使用し、アプリの依存には追加していない。RSpec はプロジェクトの CI と同様に PostgreSQL・Redis・Chrome が必要。本番アセット生成には `SECRET_KEY_BASE` などの起動用設定も必要。

確認結果: Ruby 3.3.5 / Node.js 22.23.3 で、既存の RSpec 一式は 214 examples、0 failures、1 pending（既存の `xscenario`）。RSpec 本体は 56.2 秒。RuboCop は 119 ファイルで違反なし、Prettier、本番アセット生成、固定 lockfile での依存解決も成功した。テストは追加していない。

RSpec とビルドは、外部通信を遮断し、空の環境変数からダミー設定だけを渡した一時環境で実行した。専用の PostgreSQL・Redis を使用し、ブラウザーにはローカルの ChromeDriver を指定した。元の checkout、既存サービスやデータベースは変更していない。
