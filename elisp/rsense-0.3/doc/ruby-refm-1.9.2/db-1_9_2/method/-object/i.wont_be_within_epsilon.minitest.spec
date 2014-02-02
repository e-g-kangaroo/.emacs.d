kind=added
names=wont_be_within_epsilon
visibility=public 

--- wont_be_within_epsilon(actual, epsilon = 0.001) -> true
自身と実際の値の相対誤差が許容範囲内でない場合、検査にパスしたことになります。

@param actual 実際の値を指定します。

@param epsilon 相対誤差を指定します。

@raise MiniTest::Assertion 検査に失敗した場合に発生します。

@see [[m:MiniTest::Assertions#refute_in_epsilon]]

