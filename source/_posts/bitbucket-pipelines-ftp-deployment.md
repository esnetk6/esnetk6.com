title: BitbucketからFTPサーバーにデプロイ
date: 2017-10-11 00:00:00
tags:
- bitbucket

description: BitbucketからFTPサーバーにデプロイする方法を探すと「Bitbucket Sync」を使っている情報が多い気がしますが、現在はこのスクリプトじゃなく「Pipelines」を使うようにとの案内があるので、その手順をメモ。
---

BitbucketからFTPサーバーにデプロイする方法を探すと「[Bitbucket Sync](https://github.com/alixandru/bitbucket-sync/)」を使っている情報が多い気がしますが、現在はこのスクリプトじゃなく[Pipelines](https://ja.atlassian.com/software/bitbucket/features/pipelines)を使うようにとの案内があるので、その手順をメモ。


## 使用したサーバー

お名前.com レンタルサーバー（SD-11プラン）で確認済。
さくらのレンタルサーバー（スタンダードプラン）でも実行しましたが、この方法ではデプロイできませんでした（2017年10月現在）。

### 注意：デプロイ先のディレクトリを空の状態にしておくこと

デプロイ対象のディレクトリの中が空になっていないと失敗します。ファイルを削除しておいてください。


## リポジトリの用意

今回は新規のリポジトリを作成しました。


## Pipelinesを有効にする

リポジトリの「設定」→「PIPELINES」→「Settings」→「Enable Pipelines」 で有効にします。
続いて「Configure bitbucket-pipelines.yml」をクリックします。

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot1.png)


## bitbucket-pipelines.ymlの作成

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot2.png)

Pipelinesの設定画面に飛びます。
「Choose a language template」のいずれかの言語をクリックするとymlの編集画面が表示されるので[Bitbucket Sync](https://github.com/alixandru/bitbucket-sync/)の概要にあるコードを貼り付けるのですが、現時点ではインデントに間違いがあるらしくエラーが出ます。以下のコードに直してください。

ついでに11行目の `ftp://ftp.change-this.ro/` を自分のデプロイ先に置き換えます。
例： `ftp://ftp**.gmoserver.jp/deploy-test/`


```
image: samueldebruyn/debian-git
 
pipelines:
  default:
    - step:
        script:
          - echo "Pipeline Init"
          - apt-get update
          - apt-get -qq install git-ftp
          - echo "Initiating Push"
          - git ftp init --user $FTP_USERNAME --passwd $FTP_PASSWORD ftp://ftp.change-this.ro/
          - echo "Done Pushing"
```

編集が終わったら「Commit file」をクリックします。Pipelinesが動きますが、1回目はコケます。


![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot3.png)


## 環境変数の設定

リポジトリの「設定」→「PIPELINES」→「Environment variables」画面に移ります。
`FTP_USER` と `FTP_PASSWORD` という変数を用意して、アカウント、パスワードを入力します。

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot4.png)


## 再実行

リポジトリの「Pipelines」メニューから、行なわれた処理を選択すると詳細画面に移ります。
タイトル下のFailedとなっているエリアの右側に「Rerun」という項目があるのでクリック。

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot5.png)


## デプロイ成功

FailedがSuccessfulになればデプロイ成功。
成功しなかった場合、対象ディレクトリが空になっていなかったか、そもそもお使いのサーバーがこの方法に対応していない可能性があります。

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot6.png)

デプロイ先をFTPクライアントで見てみると以下のとおり。今回は新規のリポジトリなのでファイルがこれしかありません。

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot7.png)


## bitbucket-pipelines.ymlの編集

初回のデプロイが成功したら、再度bitbucket-pipelines.ymlを編集し、11行目 `git ftp init` を `git ftp push` に書き換えます。

下の例では「ソース」からオンライン上で編集しています。

![](/2017/10/bitbucket-pipelines-ftp-deployment/screenshot8.png)

編集後、再度Pipelinesの処理が行われます。
以降、ソースが更新されるたびに自動デプロイが行われます。