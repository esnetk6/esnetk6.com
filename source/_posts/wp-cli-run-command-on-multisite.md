title: WP-CLIをマルチサイト上の別ブログで使う
date: 2017-08-02 06:40:00
tags:
- wordpress
- wp-cli

description: マルチサイト上のメインサイトとは別のブログでWP-CLIコマンドを使う方法。マルチサイトを作成するコマンドではありません。
---

マルチサイト上のメインサイトとは別のブログでWP-CLIコマンドを使う方法。
マルチサイトを作成するコマンドではありません。


## マルチサイトの例

以下のようにマルチサイト（サブディレクトリ型）を作っていたとして、
普通にWP-CLIコマンドを使ってもメインのサイト（1つ目）の方でしか動作しません。

* http://wocker.dev/
* http://wocker.dev/test/　←こっちで使いたい


## "url" オプションを使う

`--url=<url>` で指定のサイト上でコマンドが使えます。これだけです。

```sh
$ wp post create --url="wocker.dev/test/" --post_title="test"
```


## URL直接ではなくブログIDの指定でコマンドを叩く

```sh
$ wp post create --url=$(wp site url 2) --post_title="test"
```

`--url=$(wp site url 2)` が何なのかは以下で説明。


## "wp site" でブログ情報を取得

`wp site list` で、ネットワーク上のブログ一覧が表示されます。

```sh
$ wp site list
blog_id	url	last_updated	registered
1	http://wocker.dev/	2017-07-04 10:29:08	2017-05-08 22:01:25
2	http://wocker.dev/test/	2017-07-04 10:36:25	2017-05-08 22:07:17
```

`wp site url` で、ブログIDからURLを取得。

```sh
$ wp site url 2
http://wocker.dev/test/
```

