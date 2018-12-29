title: WP-CLIで固定ページのテンプレートを指定する
date: 2017-08-01 14:30:00
tags:
- wordpress
- wp-cli

description: WP-CLIで固定ページのテンプレートを指定するときは、wp post コマンドのオプションで --page_template="template-sample.php" のようにファイル名を指定します。
---

![](/2017/08/wp-cli-set-page-template/screenshot1.png)

`wp post` コマンドのオプションで `--page_template="template-sample.php"` のようにファイル名を指定します。


## ページの新規作成と同時にテンプレートを指定する場合

* [wp post create](https://developer.wordpress.org/cli/commands/post/create/)

```sh
$ wp post create --post_type="page" --page_template="template-sample.php"
```


## 作成済みのページのテンプレートを変更する場合

* [wp post update](https://developer.wordpress.org/cli/commands/post/update/)

```sh
$ wp post update 123 --page_template="template-sample.php"
```

デフォルトテンプレートに戻したいときは "page.php" ではなく "default"。

```sh
$ wp post update 123 --page_template="default"
```


## テンプレートが指定されたページ一覧を取得する

```sh
$ wp post list --post_type="page" --meta_value="template-sample.php" --meta_key="_wp_page_template"
```

### デフォルトテンプレートのページ一覧を取得する

`--meta_value="default"` に変更。

```sh
$ wp post list --post_type="page" --meta_value="default" --meta_key="_wp_page_template"
```

ただし、WP-CLIで作成したページは `--page_template` を指定しなかった場合、 `meta_key="_wp_page_template"` および `meta_value` がセットされないようです。

そのため上記のコマンドでデフォルトテンプレートのページを取得したいとき、あるいはテーマ側で `get_posts` 等を使ってデフォルトテンプレートのページを表示させたいとき（あるかわからないけど）に、正しく記事を取得できなくなる恐れがあります。

`wp post create --page_template="default"` で常に作っておくと安心かもしれません。


## あるテンプレートの記事をすべて別のものに変更する

たとえば "sample1.php" の記事をすべて "sample2.php" に変更したいというとき。

```sh
$ wp post update $(wp post list --post_type="page" --format="ids" --meta_value="sample1.php" --meta_key="_wp_page_template") --page_template="sample2.php"
```