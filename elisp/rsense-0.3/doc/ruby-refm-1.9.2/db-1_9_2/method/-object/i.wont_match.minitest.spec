kind=added
names=wont_match
visibility=public 

--- wont_match(regexp) -> true

自身がが与えられた正規表現にマッチしなかった場合、検査にパスしたことになります。

@param regexp 正規表現か文字列を指定します。文字列を指定した場合は正規表現に変換してから
              使用します。

@raise MiniTest::Assertion 自身が与えられた正規表現にマッチした場合に発生します。

@see [[m:MiniTest::Assertions#refute_match]]

