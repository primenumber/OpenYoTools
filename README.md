OpenYoTools
====

OpenYoをコマンドラインから扱うためのツール

## 使い方

### 初期設定

endpoint: https://OpenYo.nna774.net
username: hoge
password: pass
で設定する場合の初期設定

$ ./openyo.rb set endpoint https://OpenYo.nna774.net
$ ./openyo.rb create\_user hoge pass

### Yo

poyoさんにYoを送信

$ ./openyo.rb yo poyo

### YoALL

$ ./openyo.rb yoall

### Count Total Friends

$ ./openyo.rb friends\_count

### List Friends

$ ./openyo.rb list\_friends
