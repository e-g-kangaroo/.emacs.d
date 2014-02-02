kind=added
names=wont_be_close_to,wont_be_within_delta
visibility=public 

--- wont_be_within_delta(actual, delta = 0.001) -> true
--- wont_be_close_to(actual, delta = 0.001) -> true

自身と実際の値の差の絶対値が与えられた絶対誤差より大きい場合、検査にパスしたことになります。

@param actual 実際の値を指定します。

@param delta 絶対誤差を指定します。

@raise MiniTest::Assertion 自身と実際の値の差の絶対値が与えられた差分以下である場合に発生します。

@see [[m:MiniTest::Assertions#refute_in_delta]]

