# ポートフォリオ

## 概要

サービス名：**DigLive**

- [サイトURL](http://dig-live.com)

『DigLive』はYouTubeのお気に入りのライブ映像(音楽)をシェアできるSNSサービスです。

まだ知らないライブ映像を発掘して新しい音楽に出会う、というコンセプトで制作しました。

＊ゲストログイン機能を実装していますのでどなたでもお気軽にお試しください！

### 想定ユーザー

以下のような方を想定したサービスです。

- ジャンルを問わず、色々な音楽が好きな方
- 新しい音楽を主体的に探すのは面倒だと思っている方
- ライブ映像を見るのが好きな方
- 布教したいライブ映像やアーティストがいる方

## 画面イメージ

### トップページ

![トップ_ログイン前_PC.jpg](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/626595/c312ae7b-0bbb-2812-0aa4-dcc3808b65d8.jpeg)

### 投稿画面

投稿は即時、投稿一覧に反映されます。

![投稿画面デモ.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/626595/47e1e2e2-4fa4-15d6-fb94-9d844997c037.gif)

### 検索画面

選択したジャンルで投稿・ユーザをそれぞれ検索可能です。

![検索画面デモ.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/626595/e71f5b1b-1192-af1f-4356-2189ecde8690.gif)


## 技術面

### 力を注いだ点

- フロントエンド(Nuxt.js)とバックエンド(Rails)を分けて開発し、API通信によってコンテンツを動的に切り替えるSPAとしてサービス運用している
- Vuexにデータを一時保管することで、再ロード防止による高速化、画面ごとの表示切り替えを実現している
- Vue.jsのリアクティブな性質を活かし、ユーザーの操作を即時変更し画面に反映している
- JWTを利用し、Railsが発行したトークンでログイン時のトークン認証・セッション永続化を実現している
- vue-infinite-loadingで各種リソースを無限スクロール表示することで、ページネーションをスムーズにしている
- Vuetifyを利用し、PC・タブレット・スマートフォンそれぞれのデバイスで見やすいようレスポンシブデザインを実現している
- middlewareを用いて、ログイン前ユーザはログイン画面へ、ログイン済ユーザはホーム画面へとリダイレクトを行っている
- Dockerでアプリをコンテナ化することで、開発/本番での環境間差異トラブルを低減している
- Docker-Composeでコンテナ化アプリケーションを効率的に管理している
- AWS ECS(Fargate)を利用し、Dockerイメージの管理のみに集中できるサーバーレスな運用を実現している
- AWS Route53/ACM/ALBを用いて、独自ドメイン＋常時SSL通信(HTTPS)を実現している
- AWS SSMに本番環境用の環境変数をシークレット保存し、ECSタスク起動時に読み込ませている
- Terraformを利用し、インフラをコードで管理している
- CircleCIでCI/CDパイプラインを構築し、Orbと連携することでコードの変更を自動的に本番環境(AWS ECS/ECR)に反映している
- Rspec、Jestを用いてテスト環境を整備している
- Git, GitHubのブランチ/Issue/PR等を活用し、実務を意識した開発をしている


### 使用技術

- **バックエンド**
    - Ruby 2.7.6
    - Rails 6.0.5.1 (API mode)
    - rspec-rails (5.0.3)
- **フロントエンド**
    - vue@2.7.8
    - nuxt@2.15.8 (SPA mode)
    - @nuxtjs/vuetify@1.12.3
    - jest@29.1.2
- **開発環境**
    - Docker 20.10.12
    - Docker-Compose 1.29.2
- **インフラ**
    - AWS(ECS, ECR, ACM, ALB, CloudWatch, RDS, Route53, S3, SSM, VPC)
    - Terraform v1.3.1
    - CircleCI

## 実装機能

### 投稿関連

- **作成機能**
    - 入力フォームをモーダルで表示(URL、コメント、ジャンル、タグ)
    - 入力フォームのバリデーション(URL、コメント)
    - タグの自由入力・オートコンプリート(vue-tags-input)
- **表示機能**
    - 表示パターン
        - 投稿一覧
        - 投稿詳細
        - フォローユーザの投稿一覧
        - ユーザの投稿一覧
        - ユーザのいいねした投稿一覧
    - YouTube動画を埋め込み表示・再生(YouTube API)
    - 一覧表示で無限スクロール(vue-infinite-loading)
- **検索機能**
    - 音楽ジャンル検索(固定表示)
    - タグ検索(ユーザの投稿からDB登録しランダムに数件表示)
    - キーワード検索
- **削除機能**
    - 全表示パターンから可能
    - 確認フォームをモーダルで表示(削除する投稿の内容)
- **いいね機能**
    - 全表示パターンから可能
- **コメント機能**
    - 投稿詳細から可能
    - 入力フォームをモーダルで表示(コメント)
    - 入力フォームのバリデーション(コメント)

### ユーザー関連

- **認証機能**(JWT)
    - 新規登録
        - 入力フォームのバリデーション(ユーザー名、メールアドレス、パスワード)
    - ログイン機能
        - 入力フォームのバリデーション(メールアドレス、パスワード)
    - ゲストユーザーログイン機能
    - ログアウト機能
    - サイレントリフレッシュでセッション維持
- **表示機能**
    - 表示パターン
        - ユーザー一覧
        - ユーザー詳細
        - フォローしたユーザ一覧
    - 一覧表示で無限スクロール(vue-infinite-loading)
- **検索機能**
    - 音楽ジャンル検索(固定表示)
    - キーワード検索
- **編集機能**
    - プロフィール編集
        - 入力フォームをモーダルで表示(ユーザー名、プロフィール、アバター画像、好きな音楽ジャンル)
    - アカウント情報編集
        - 入力フォームをモーダルで表示(メールアドレス、パスワード)
- **削除機能**
    - アカウント情報削除
        - 確認フォームをモーダルで表示(削除意思の確認)
- **フォロー/アンフォロー機能**
    - 全表示パターンから可能
- **通知機能**
    - 通知タイミング
        - いいね時(1つの投稿に対し初回のみ)
        - コメント時
        - フォロー時(1人のユーザーに対し初回のみ)
    - 無限スクロール(vue-infinite-loading)

## ER図

![DigLive_ER.drawio.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/626595/508e7d95-f8d4-e85b-388c-f851883da631.png)


## インフラ構成図

![DigLive_Infla.drawio.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/626595/3b2405cd-b35e-8b3e-beba-5236ad236755.png)


