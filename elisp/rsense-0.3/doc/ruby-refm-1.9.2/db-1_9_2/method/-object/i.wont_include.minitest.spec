kind=added
names=wont_include
visibility=public 

--- wont_include(object) -> true
自身にオブジェクトが含まれていない場合、検査にパスしたことになります。

@param object 任意のオブジェクトを指定します。

@raise MiniTest::Assertion 自身が include? メソッドを持たない場合に発生します。
                           与えられたコレクションにオブジェクトが含まれている場合に発生します。

@see [[m:MiniTest::Assertions#refute_includes]]

