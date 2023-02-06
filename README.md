# TPCH benchmark adapted to Clickhouse SQL syntax

## Description

In this repository there is a translation of the TPCH benchmark suite to Clickhouse SQL syntax, this benchmark suite is one of the industry standards in measuring performance of analytical queries. Clickhouse is an OLAP data management system that follows a column-based approach to store information, like many other popular systems such as MonetDB or Apache Parquet. 

Clickhouse does not strictly follow the standard SQL syntax, and even some of the simplest features from traditional relational databases like transactions or Foreign Keys are not supported. One of the main issues that had to be addressed to make TPCH queries work in Clickhouse was nested queries, since the selected attributes in an outer query are not visible in the inner ones. This prevents many queries in the benchmarking suite from executing that had WHERE conditions that references attributes from outer queries.

## Cheatsheet

To start a new server you can run the command `clickhouse server &`, it will create some files and subdirectories to manage the created database and store data so make sure you do it somewhere with enough space and where it does not matter to have additional files. 

Depending on the installation method, you might have separate biaries for the server and client `clickhouse-server`/`clickhouse-client`. Running any SQL code in the CLI is as easy as executing `clickhouse client -q "CREATE DATABASE IF NOT EXISTS sf3"`, but you can also execute a SQL script in the following manner: `clickhouse client -n --queries-file tpch_ch_schema.sql -d sf3`

The previous commands actually create the database sf3 and loads the schema for the TPCH table layout. We still need to generate the data (this must be done with the scripts provided by the official TPCH organization, that can be found [here](https://tpc.org/TPC_Documents_Current_Versions/download_programs/tools-download-request5.asp?bm_type=TPC-H&bm_vers=3.0.0&mode=CURRENT-ONLY))

Once you have generated the data for the scale factor you are going to execute, you can run the following script `ch_horizontal_run.sh` so as to execute the different queries. By default, each query is run 3 times to account for cold start effects. The mean, min and max execution times are printed an stored into a `timings.csv` file.

## Issues 

By default, the client only waits for 300s for a query response from the server. Since queries 7 and 19 did not actually end for a Scale Factor of 3. You might need increase timeout creating the following file via `vim ~/.clickhouse-client/config.xml` and adding:

```
<config>
 <receive_timeout>7200</receive_timeout>
 <send_timeout>7200</send_timeout>
</config>
```

# NotNull 和 Nullable TPCH 压测

## 准备数据

1. 从[这](https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp)下载 [TPC-H_Tools_v3.0.1.zip](https://www.tpc.org/TPC_Documents_Current_Versions/download_programs/tools-download-request5.asp?bm_type=TPC-H&bm_vers=3.0.1&mode=CURRENT-ONLY)，并解压

2. 修改 makefile，在 `TPC-H V3.0.1/dbgen` 目录下找到 makefile.suite

   ```makefile
   
   -- vi makefile.suite
   
   ################
   ## CHANGE NAME OF ANSI COMPILER HERE
   ################
   CC      = gcc
   # Current values for DATABASE are: INFORMIX, DB2, TDAT (Teradata)
   #                                  SQLSERVER, SYBASE, ORACLE
   # Current values for MACHINE are:  ATT, DOS, HP, IBM, ICL, MVS,
   #                                  SGI, SUN, U2200, VMS, LINUX, WIN32
   # Current values for WORKLOAD are:  TPCH
   DATABASE= ORACLE  #修改这三行
   MACHINE = LINUX   #
   WORKLOAD = TPCH   #
   ```

3. 构建 `make -f makefile.suite`

4. **进入 s100目录**，执行  `${tpctool}/dbgen -s 100 -f`

5. 加载数据：

   ```bash
   # 前置条件，自己编译 clickhouse
   # nullable
   time ./upload-data.sh -d tpch_null -c tpch_null.sql -s 100
   # notnual
   time ./upload-data.sh -d tpch_notnull -c tpch_notnull.sql -s 100
   ```

## 压测

直接运行 `./runall`

