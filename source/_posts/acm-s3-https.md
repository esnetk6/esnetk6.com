title: CloudFront + ACMでブログをHTTPS化した
date: 2018-02-15 00:00:00
tags:
- aws

description: Hexo + S3で動いているブログをHTTPS化しました。
---

Hexo + S3で動いているブログをHTTPS化しました。

ACMを使うにあたって申請ドメインでメールを受信できるようにしなければならないと聞いて面倒に感じていたんですが、SESでメールも受信できて無事完了しました。


## 参考

これらの記事のおかげで設定できました。
本当にありがとうございます。

* [S3+CloudFront+ACM(AWS Certificate Manager)でHTTPS静的サイトを作ってみた - Qiita](https://qiita.com/toshihirock/items/914f408cd565b66fe9f9)
* [AWS Certificate Manager (ACM)で申請前に事前に確認しておくべき大切なこと - Qiita](https://qiita.com/toshihirock/items/cf4e6d8afa08beaa728c)
* [[CloudFront + S3]特定バケットに特定ディストリビューションのみからアクセスできるよう設定する ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/cloudfront-s3-origin-access-identity/)
* [[ACM] AWS Certificate Manager 無料のサーバ証明書でCloudFrontをHTTPS化してみた ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/acm-cloudfront-ssl/)
* [Amazon S3でSSL対応の静的ウェブサイトを公開する | マジメナラボ - majimena Inc.](https://blog.majimena.co.jp/tech/2016/03/31/aws-ssl.html)
* [【そんなときどうする？】メールサーバはないけれどACMを使いたい！ &#8211; サーバーワークスエンジニアブログ](http://blog.serverworks.co.jp/tech/2016/06/30/acm-auth-method/)
* [Amazon Certificate ManagerのTokyo RegionでSSL取得してもCloudFrontでは表示されない | Timegraphy](https://thetimegraphy.com/aws-amazon-certificate-manager-tokyo-region-does-not-support-cloudfront/)
