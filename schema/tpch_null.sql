DROP DATABASE IF EXISTS tpch_null;
CREATE DATABASE tpch_null;


CREATE TABLE tpch_null.customer
(
    c_custkey     Nullable(bigint),
    c_name        Nullable(String),
    c_address     Nullable(String),
    c_nationkey   Nullable(bigint),
    c_phone       Nullable(String),
    c_acctbal     Nullable(double),
    c_mktsegment  Nullable(String),
    c_comment     Nullable(String)
)
    engine MergeTree()
        ORDER BY tuple();



CREATE TABLE tpch_null.lineitem
(
    l_orderkey       Nullable(bigint),
    l_partkey        Nullable(bigint),
    l_suppkey        Nullable(bigint),
    l_linenumber     Nullable(bigint),
    l_quantity       Nullable(double),
    l_extendedprice  Nullable(double),
    l_discount       Nullable(double),
    l_tax            Nullable(double),
    l_returnflag     Nullable(String),
    l_linestatus     Nullable(String),
    l_shipdate       Nullable(date),
    l_commitdate     Nullable(date),
    l_receiptdate    Nullable(date),
    l_shipinstruct   Nullable(String),
    l_shipmode       Nullable(String),
    l_comment        Nullable(String)
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_null.nation
(
    n_nationkey  Nullable(bigint),
    n_name       Nullable(String),
    n_regionkey  Nullable(bigint),
    n_comment    Nullable(String)
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_null.region
(
    r_regionkey  Nullable(bigint),
    r_name       Nullable(String),
    r_comment    Nullable(String)
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_null.orders
(
    o_orderkey       Nullable(bigint),
    o_custkey        Nullable(bigint),
    o_orderstatus    Nullable(String),
    o_totalprice     Nullable(double),
    o_orderdate      Nullable(date),
    o_orderpriority  Nullable(String),
    o_clerk          Nullable(String),
    o_shippriority   Nullable(bigint),
    o_comment        Nullable(String)
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_null.part
(
    p_partkey      Nullable(bigint),
    p_name         Nullable(String),
    p_mfgr         Nullable(String),
    p_brand        Nullable(String),
    p_type         Nullable(String),
    p_size         Nullable(bigint),
    p_container    Nullable(String),
    p_retailprice  Nullable(double),
    p_comment      Nullable(String)
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_null.partsupp
(
    ps_partkey     Nullable(bigint),
    ps_suppkey     Nullable(bigint),
    ps_availqty    Nullable(bigint),
    ps_supplycost  Nullable(double),
    ps_comment     Nullable(String)
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_null.supplier
(
    s_suppkey    Nullable(bigint),
    s_name       Nullable(String),
    s_address    Nullable(String),
    s_nationkey  Nullable(bigint),
    s_phone      Nullable(String),
    s_acctbal    Nullable(double),
    s_comment    Nullable(String)
)
    engine MergeTree() ORDER BY tuple();