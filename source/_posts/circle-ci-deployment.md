title: Circle CIでwebサイトを自動デプロイ
date: 2018-04-02 20:30:00
tags:
- github
- bitbucket
- circle-ci

description: Circle CI 2.0を使って、GitHub or BitbucketからWebサイトを自動デプロイさせます。masterブランチは本番サーバーへ、developブランチはテストサーバーへ分けてデプロイさせるといったことも可能です。
---

Circle CI 2.0を使って、GitHub or BitbucketからWebサイトを自動デプロイさせます。masterブランチは本番サーバーへ、developブランチはテストサーバーへ分けてデプロイさせるといったことも可能です。

テストなんてどうでもいいから、とりあえず自動デプロイだけ実現してFTPクライアントでのアップロード作業から逃れたい！と思っていた自分のためのメモです。

今回紹介する方法ではsshの使えるサーバーが必要です。
Circle CIからデータをあげたり削除したりするので、最初は失敗してもいい環境で試すのをおすすめします。自己責任でおねがいします。


## Circle CIの設定ファイルを作成してリポジトリにPush

リポジトリ直下に `.circleci/config.yml` を作ります。ファイルの中身は以下をコピペ。
**用意できたらGitHub or BitbucketのリポジトリにPushしておきます。**

```
# Environment variables
# - HOST_NAME
# - USER_NAME
 
version: 2
jobs:
  build:
    docker:
      - image: circleci/php:7.1-browsers
 
    steps:
      - checkout
 
      - add_ssh_keys:
          fingerprints:
            - "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
 
      - run:
          name: Start ssh-keyscan
          command: |
            ssh-keyscan ${HOST_NAME} >> ~/.ssh/known_hosts
 
      - deploy:
          name: Start master deploy
          command: |
            if [ "${CIRCLE_BRANCH}" == "master" ]; then
                rsync -av --delete --exclude='.git' --exclude='.circleci' ./ ${USER_NAME}@${HOST_NAME}:/var/www/html/
            fi
```


## Circle CIにログイン

Circle CIにGitHub or Bitbucketのアカウントでログインします。
http://circleci.com/


## リポジトリを選択する

左のProjectから "Add Project" をクリックするとリポジトリ一覧が表示されます。
さきほどconfig.ymlをPushしたリポジトリの "Setup Project" をクリック。

![](/2018/04/circle-ci-deployment/screenshot1.png)

![](/2018/04/circle-ci-deployment/screenshot2.png)


## 設定画面

プロジェクトの初期設定画面が表示されますが、push済みのconfig.ymlで指定してあるので、ここでは何も押さずにスクロールしていって "Start building" をクリック。

![](/2018/04/circle-ci-deployment/screenshot3.png)

![](/2018/04/circle-ci-deployment/screenshot4.png)


## 1回目のビルド

ビルドが始まりますが1回目は失敗します。Failedとなって以下のように赤くなるはずです。

環境変数等の設定画面に移動するため歯車アイコンをクリック。

![](/2018/04/circle-ci-deployment/screenshot5.png)


## 設定画面

![](/2018/04/circle-ci-deployment/screenshot6.png)


## 秘密鍵の登録

Circle CIに秘密鍵を登録します。
メニューからPermissions > SSH Permissions > Add SSH keyをクリック。

![](/2018/04/circle-ci-deployment/screenshot7.png)

Hostname（例：example.com）と秘密鍵の中身を登録。最初と最後の行も含めてください。

```
-----BEGIN RSA PRIVATE KEY-----
（略）
-----END RSA PRIVATE KEY-----
```

![](/2018/04/circle-ci-deployment/screenshot8.png)

登録すると以下のようにFingerprintがセットされます。この値は後で使います。

![](/2018/04/circle-ci-deployment/screenshot9.png)


## 環境変数の設定

今回用意したconfig.ymlでは2つの環境変数を使っています。
sshで接続する時のホスト名 `HOST_NAME` と、ユーザー名 `USER_NAME` です。
例として `ssh_user@example.com` で接続するものとして進めます。

環境変数はメニューからBuild Settings > Environment Variables > Add variableで登録。

![](/2018/04/circle-ci-deployment/screenshot10.png)

1つめはHOST_NAME。valueにホスト名を入力（例：example.com）。

![](/2018/04/circle-ci-deployment/screenshot11.png)

2つめはUSER_NAME。valueにユーザー名を入力（例：ssh_user）。

![](/2018/04/circle-ci-deployment/screenshot12.png)

登録すると以下のようになっているはずです。
Circle CI画面での設定はここまで。

![](/2018/04/circle-ci-deployment/screenshot13.png)


## config.ymlの編集

エディターで `.circleci/config.yml` を開いて編集します。

### Fingerprintの差し替え

先ほど秘密鍵を登録したあとに表示されたFingerprintをコピーして、16行目の `"xx:xx:xx..."` となっている箇所に貼り付けます。

```
- add_ssh_keys:
    fingerprints:
      - "a2:6d:ec:7e:53:a5:4b:d7:72:78:0e:d1:d4:ee:b2:02"
```


### デプロイ先ディレクトリの変更

27行目のrsyncコマンドで、リポジトリの `./` ディレクトリ以下をアップロードさせます。`/` から始めると余計なものがアップされてしまうので注意。

デプロイ先が `/var/www/html/` となっているのでディレクトリを変更してください。

```
rsync -av --delete --exclude='.git' --exclude='.circleci' ./ ${USER_NAME}@${HOST_NAME}:/var/www/html/
```

`--delete` オプションを指定しているので、リポジトリのファイルを削除するとサーバー側の同じファイルが自動的に削除されてしまうのでご注意ください。
`--exclude` オプションで、config.ymlと.gitフォルダ内がアップされないようにしています。


### ポート番号の指定（サーバーによって必要）

たとえばエックスサーバーのようにssh接続にポート番号（10022）が指定されている場合は、config.ymlでもポート番号を指定しておきます。

### 21行目

```
ssh-keyscan ${HOST_NAME} >> ~/.ssh/known_hosts
```

から

```
ssh-keyscan -p 10022 ${HOST_NAME} >> ~/.ssh/known_hosts
```

### 27行目

```
rsync -av --delete --exclude='.git' --exclude='.circleci' ./ ${USER_NAME}@${HOST_NAME}:/var/www/html/
```

から

```
rsync -av --delete --rsh="ssh -p 10022" --exclude='.git' --exclude='.circleci' ./ ${USER_NAME}@${HOST_NAME}:/var/www/html/
```

## config.ymlをpush

* Fingerprintの差し替え
* デプロイ先ディレクトリの変更
* ポート番号の指定

ができたら、config.ymlをpushします。
pushやプルリクのマージによってソースに変更があるとCircle CIが動くようになっているので、左上のBUILDSへ行くと新しいビルドがスタートしているはずです。

1回目はFailedでしたが、Fixed（緑色）になったらビルド成功です。

![](/2018/04/circle-ci-deployment/screenshot14.png)

正しくファイルがアップされたかどうか、ブラウザやFTPクライアント等で確認してください。
いらないファイルがアップされていたりしたら、rsyncの `--exclude` で除外するファイルやフォルダを指定します。

config.yml以外のソースの変更をしてpushしてみたときに再度デプロイされるかどうかも確認します。正しく動いていたらおしまいです。


## 特定のブランチ以外はCircle CIを動かさない

書いておくと余計なビルドがなくなります。

https://circleci.com/docs/2.0/configuration-reference/#branches

```
jobs:
  build:
    branches:
      only:
        - master
```


## ブランチごとにデプロイ先を変える

masterは本番サーバーへ、developはテストサーバーへデプロイさせたい、みたいなとき。

* 秘密鍵を追加した場合、fingerprintも増えます（行を追加すればOK）。
* デプロイ先が増えるので、環境変数も追加します。


```
# Environment variables
# - HOST_NAME
# - USER_NAME
# - HOST_NAME_DEV
# - USER_NAME_DEV

version: 2
jobs:
  build:
    docker:
      - image: circleci/php:7.1-browsers
 
    branches:
      only:
        - master
        - develop
 
    steps:
      - checkout
 
      - add_ssh_keys:
          fingerprints:
            - "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
            - "yy:yy:yy:yy:yy:yy:yy:yy:yy:yy:yy:yy:yy:yy:yy:yy" #追加
 
      - run:
          name: Start ssh-keyscan
          command: |
            ssh-keyscan ${HOST_NAME} >> ~/.ssh/known_hosts
            ssh-keyscan ${HOST_NAME_DEV} >> ~/.ssh/known_hosts #追加
 
      - deploy:
          name: Start master deploy
          command: |
            if [ "${CIRCLE_BRANCH}" == "master" ]; then
                rsync -av --delete --exclude='.git' --exclude='.circleci' ./ ${USER_NAME}@${HOST_NAME}:/var/www/html/
            fi
 
      # 追加
      - deploy:
          name: Start develop deploy
          command: |
            if [ "${CIRCLE_BRANCH}" == "develop" ]; then
                rsync -av --delete --exclude='.git' --exclude='.circleci' ./ ${USER_NAME_DEV}@${HOST_NAME_DEV}:/var/www/html/
            fi
```


## 参考

"Are you sure you want to continue connecting (yes/no)?" をきかれてビルドがストップしないようにするためにどうすればいいか調べたところ、以下の記事が参考になりました。

* [初回SSH接続時の対話的Fingerprint確認フローをssh-keyscanでスキップする - Qiita](https://qiita.com/pinkumohikan/items/b6fa4233068e7e98e22d)
