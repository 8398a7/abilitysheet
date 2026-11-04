# Railsセキュリティ更新（2026-11-04）

[Railsのリリース告知](https://rubyonrails.org/2026/11/4/Rails-8.0.5.2-and-8.1.4.1-have-been-released)に対応し、Railsを7.2.4から8.1.4.1へ更新した。8.0系は2026-11-07にセキュリティサポートが終了するため、8.1系を採用する。

## 変更

- 未使用のAction Cableは全環境でマウントを無効化した。`/cable`への接続要求がルーティングされないことをリクエストテストで確認する。
- `mini_magick`を5.4.0に更新し、Railsが同梱するImageMagickの安全ポリシーを適用できるようにした。画像処理の設定は既存のvipsを維持する。
- HTMLサニタイズの修正に必要なrails-html-sanitizer 1.7.2、Loofah 2.25.3、Nokogiri 1.19.7へ更新した。
- 既知の脆弱性に対応するため、Rack 2.2.25、Crass 1.0.8、Addressable 2.9.2、Ransack 4.4.4へ更新した。
- Rails更新に合わせてRSpec Railsを8.0.4に更新した。例外処理で削除済みのRails APIを呼び出していたSentry SDKは5.28.1に更新し、初期化設定も対応する名前に変更した。
- Active Record 8に非対応のAnnotateをAnnotateRb 4.26.0へ置き換えた。注釈の設定は`.annotaterb.yml`へ移し、開発時のマイグレーション後の自動実行を維持する。手動実行は`bundle exec annotaterb models`を使う。

`load_defaults 7.0`、既存のセッション設定、Sidekiqのバージョンは維持した。Rails 8.1では組み込みのSidekiqアダプターに非推奨警告が出るため、Rails 8.2へ進む際はSidekiq側のアダプターへの移行が必要になる。

## 検証

Ruby 3.3.13 / Node.js 22.23.3で、外部通信を遮断した一時環境と専用のPostgreSQL 17・Redisを使用する。既存サービスや本番データには接続しない。

```sh
bundle check
bundler-audit check --update
yarn install --frozen-lockfile
yarn lint
bundle exec rails ts:routes
bundle exec rails db:create db:migrate
bundle exec bin/rubocop_parallel
bundle exec rspec
NODE_ENV=production RAILS_ENV=production bundle exec rails assets:precompile
```

PrettierはCIと同じく、無視対象のルート定義を生成する前に実行する。追加テストはAction Cableの接続拒否1件で、既存の起動済みテスト環境を共用する。

確認結果:

- RSpecは215 examples、0 failures、1 pending（既存の`xscenario`）。本体57.34秒、読み込み2.81秒。追加した接続拒否のテストは約0.02秒で、専用のfixtureや追加サービスは起動しない。CIのジョブ定義は変更しておらず、runner待ち時間は未計測。
- RubySecのadvisory DB（`ea31421`、2026-11-04）で、lockfileに含まれるgemの脆弱性検出は0件。無視設定は追加していない。
- RuboCopは120ファイルで違反0件。固定lockfileでの依存確認、Prettier、本番アセット生成、本番環境でのeager load、開発環境でのRakeタスク読み込みも成功した。

ここに記載した検証結果はローカル環境のもの。CI・デプロイの結果は対応するPRとworkflow runを参照する。
