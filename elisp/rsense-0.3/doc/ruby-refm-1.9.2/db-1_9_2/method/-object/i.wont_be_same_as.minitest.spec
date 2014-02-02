kind=added
names=wont_be_same_as
visibility=public 

--- wont_be_same_as(actual) -> true

自身と与えられたオブジェクトの [[m:Object#object_id]] が異なる場合、検査にパスしたことになります。

@param actual 任意のオブジェクトを指定します。

@raise MiniTest::Assertion 自身と与えられたオブジェクトが同じ場合に発生します。

@see [[m:MiniTest::Assertions#refute_same]]

