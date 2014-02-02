kind=added
names=wont_be_instance_of
visibility=public 

--- wont_be_instance_of(klass) -> true

自身が与えられたクラスの直接のインスタンスでない場合、検査にパスしたことになります。

@param klass 自身が直接のインタンスでないことを期待するクラスを指定します。

@raise MiniTest::Assertion 自身が与えられたクラスの直接のインスタンスである場合に発生します。

@see [[m:MiniTest::Assertions#refute_instance_of]]

