title: ブログをS3からGitHub Pagesに移した
date: 2018-12-30 00:30:00
tags:
- github

description:
---

Amazon S3を使っていたのですがGitHub Pagesにしました。

AWSありがとう。
諸事情により移行することになりましたが速いし安いし最高でした。


## GitHub Pagesに独自ドメインを適用する

https://help.github.com/articles/setting-up-an-apex-domain/

Aレコード

* 185.199.108.153
* 185.199.109.153
* 185.199.110.153
* 185.199.111.153

### HTTPS

いつの間にかGitHub Pagesが公式で独自ドメインのHTTPS配信をサポートするようになっていました。リポジトリの設定からEnforce HTTPSにチェックを入れるだけでした。
