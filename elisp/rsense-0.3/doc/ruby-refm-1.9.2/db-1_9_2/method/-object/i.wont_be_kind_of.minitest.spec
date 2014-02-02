kind=added
names=wont_be_kind_of
visibility=public 

--- wont_be_kind_of(klass) -> true

自身が与えられたクラスまたはそのサブクラスのインスタンス
でない場合、検査にパスしたことになります。

@param klass 自身が所属しないことを期待するクラスを指定します。

@raise MiniTest::Assertion 自身が与えられたクラスまたはそのサブクラスの
                           インスタンスである場合に発生します。

@see [[m:MiniTest::Assertions#refute_kind_of]]

