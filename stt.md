# 設定
## 型
 - string
文字列
/"[\w(){}-=~^|:;?.]+"/
 - integer
 /\d+/
数値
 - tof
"true"または"false"
"true"||"falsezz"
 - cond
条件式
/\w+==\w+/
 - exp
計算式
 - var
 変数
## 造
main.rb
→ lexer/main.r
 → Lexer
→ run
## メソッド
 - print
 print 〇〇
 - 変数
 a = 0
 print a
 a = b
# コード
## 変数＆配列

@list_token　に　メソッドの種類　　　　が入る
@list_type 　に　型の種類　　　　　　　が入る
@chomp     　に　コードを区切ったもの　が入る
@token     　に　レクサー後のトークン　が入る
