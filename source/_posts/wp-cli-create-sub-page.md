title: WP-CLIで親を指定して固定ページを作る
date: 2017-04-29 21:30:00
tags:
- wordpress
- wp-cli

description: WP-CLIから固定ページを生成したいときに、親子関係も一緒に設定するためのメモです。
---

![](/2017/04/wp-cli-create-sub-page/screenshot1.png)

WP-CLIから固定ページを生成したいときに、親子関係も一緒に設定するためのメモです。


## WP-CLIで固定ページを作る

基本形から。
記事の投稿はWP-CLIの [wp post create](http://wp-cli.org/commands/post/create/) コマンドで行ないます。

```sh
wp post create --post_type=page --post_status=publish --post_title="Company" --post_name="company"
```

`--post_type=page` は固定ページとして作るための指定。
`--post_status=publish` は公開済みの記事として作るための指定。
`--post_title="Company"` は記事のタイトル。
`--post_name="company"` で記事作成時のパーマリンクの指定もできます。

![](/2017/04/wp-cli-create-sub-page/screenshot2.png)

当然、このコマンドでは記事の親は指定されていません。
※パーマリンク設定によっては `--post_name` で指定した文字列は表示されませんが、情報としては保存されているはずです。


## 親を指定する

前回のコマンドに加えて `--post_parent=ID` を指定すると、このIDに該当するページを親として子ページを作成できます。

```sh
wp post create --post_parent=20 --post_type=page ...
```


### ページのIDをスラッグから取得する

いちいちIDを調べて指定するのは面倒なので、ページのスラッグからIDを取得します。
今回は "company" の下に新たに子ページを作成したいと思います。

ページのIDを取得するには [wp post list](http://wp-cli.org/commands/post/list/) を使います。

```sh
wp post list --field=ID --post_type=page --name="company"
```

`--post_name` ではなく `--name` でスラッグを指定しないと正しく取得できませんでした。


## 親を指定して固定ページを作成

オプションの中でさらに `wp` コマンドを使用する場合は `$(wp ~ )` とすればいいので、最終的に以下のようになります。

```sh
wp post create --post_type=page --post_status=publish --post_title="Message" --post_name="message" --post_parent=$(wp post list --post_type=page --field=ID --name="company")
```

![](/2017/04/wp-cli-create-sub-page/screenshot3.png)

ちゃんと子ページとして作成できました。

ターミナルへのコピペがうまくいかなくなることが考えられるため、ここまでのコマンドには日本語が入ってませんが、WP-CLIのオプションに日本語が使えないとかいうわけではありません。普通に使えます。

一つのファイルにまとめてシェルスクリプトを実行させると一発で固定ページを作成できますね。

```sh post.sh
wp post create --post_title="業務内容" --post_name="business" --post_type=page --post_status=publish
wp post create --post_title="お問い合わせ" --post_name="contact" --post_type=page --post_status=publish
wp post create --post_title="採用情報" --post_name="recruit" --post_type=page --post_status=publish
wp post create --post_title="会社概要" --post_name="company" --post_type=page --post_status=publish
 
# 会社概要（company）の下に作成
wp post create --post_title="ご挨拶" --post_name="message" --post_type=page --post_status=publish --post_parent=$(wp post list --post_type=page --field=ID --name="company")
wp post create --post_title="アクセス" --post_name="access" --post_type=page --post_status=publish --post_parent=$(wp post list --post_type=page --field=ID --name="company")
wp post create --post_title="沿革" --post_name="history" --post_type=page --post_status=publish --post_parent=$(wp post list --post_type=page --field=ID --name="company")
```
