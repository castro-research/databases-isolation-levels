WIP

# Introduction

Isolation is the I in the acronym ACID, and here i will explore about this subject. 

The SQL:1992 standard show 4 transaction isolation levels: 

- READ UNCOMMITTED
- READ COMMITTED
- REPEATABLE READ
- SERIALIZABLE

The isolation level of a SQL-transaction is SERIALIZABLE by default, as SQL:1992 standard says.

In MySQL, The default isolation level for InnoDB engine is REPEATABLE READ. ( see references )

Read Committed is the default isolation level in PostgreSQL ( see references )

But the goal here, is not deep dive each RDBMS, but explain what each isolation involves.

# READ UNCOMMITTED

![image](https://github.com/castro-research/databases-isolation-levels/assets/10711649/7d1a0055-f161-4042-a3cb-3e1c821161cb)


# READ COMMITTED

# REPEATABLE READ

# SERIALIZABLE

# References

https://learn.microsoft.com/en-us/sql/odbc/reference/develop-app/transaction-isolation-levels?view=sql-server-ver16

https://www.postgresql.org/docs/current/transaction-iso.html

https://dev.mysql.com/doc/refman/8.0/en/innodb-transaction-isolation-levels.html

https://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt

https://www.youtube.com/watch?v=4EajrPgJAk0