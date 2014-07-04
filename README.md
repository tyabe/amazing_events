# amazing events

これは、[パーフェクトRuby on Rails](http://gihyo.jp/book/2014/978-4-7741-6516-5)の Part3 で作成されたサンプルアプリを
Padrino で作成してみたアプリケーションです。

イベント情報を登録／編集したり、イベントに参加登録したりできます。

## 前提条件

次のライブラリをインストールしておいてください。詳しくは書籍を参考にしてください。

* Ruby 2.0.0 以上
* bundler
* sqlite3
* phantomjs
* ImageMagick

## セットアップ方法

まず次のコマンドを実行します。

```
git clone git@github.com:tyabe/amazing_events.git
cd amazing_events
bundle install
bundle exec rake db:migrate
```

[Twitter Application Management](https://apps.twitter.com/) で、書籍の通りにTwitterアプリケーションを作成し、
作成したアプリケーションの Twitter Api Key と Twitter Api Secret を `.env.example` に記述し `.env` にリネームします。
その後、次のコマンドで WEBrick を起動します。

```
bundle exec padrino s
```

http://localhost:3000/ にアクセスすると、トップページが表示されているはずです。

### テストの実行方法

テストを実行する場合は、次のようにします。

```
bundle exec rake spec
```

特定のテストを実行したい場合は次のようにします。例として event_spec.rb を実行するものとします。

```
bundle exec rspec spec/models/event_spec.rb
```

