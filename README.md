# FMDBDemo
FMDB温故而知新(基本使用、多线程、事务、多线程事务)

### 三个基本类

FMDatabase: 代表一个 SQLite 数据库,用于执行 SQLite 语句;

FMResultSet:表示FMDatabase执行查询后结果集

FMDatabaseQueue:如果你想在多线程中执行多个查询或更新，你应该使用该类。这是线程安全的。


