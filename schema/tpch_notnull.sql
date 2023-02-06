DROP DATABASE IF EXISTS tpch_notnull;
CREATE DATABASE tpch_notnull;


CREATE TABLE tpch_notnull.customer
(
    c_custkey    bigint not null,
    c_name       String not null,
    c_address    String not null,
    c_nationkey  bigint not null,
    c_phone      String not null,
    c_acctbal    double not null,
    c_mktsegment String not null,
    c_comment    String not null
)
    engine MergeTree()
        ORDER BY tuple();



CREATE TABLE tpch_notnull.lineitem
(
    l_orderkey      bigint not null,
    l_partkey       bigint not null,
    l_suppkey       bigint not null,
    l_linenumber    bigint not null,
    l_quantity      double not null,
    l_extendedprice double not null,
    l_discount      double not null,
    l_tax           double not null,
    l_returnflag    String not null,
    l_linestatus    String not null,
    l_shipdate      date not null,
    l_commitdate    date not null,
    l_receiptdate   date not null,
    l_shipinstruct  String not null,
    l_shipmode      String not null,
    l_comment       String not null
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_notnull.nation
(
    n_nationkey bigint not null,
    n_name      String not null,
    n_regionkey bigint not null,
    n_comment   String not null
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_notnull.region
(
    r_regionkey bigint not null,
    r_name      String not null,
    r_comment   String not null
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_notnull.orders
(
    o_orderkey      bigint not null,
    o_custkey       bigint not null,
    o_orderstatus   String not null,
    o_totalprice    double not null,
    o_orderdate     date not null,
    o_orderpriority String not null,
    o_clerk         String not null,
    o_shippriority  bigint not null,
    o_comment       String not null
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_notnull.part
(
    p_partkey     bigint not null,
    p_name        String not null,
    p_mfgr        String not null,
    p_brand       String not null,
    p_type        String not null,
    p_size        bigint not null,
    p_container   String not null,
    p_retailprice double not null,
    p_comment     String not null
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_notnull.partsupp
(
    ps_partkey    bigint not null,
    ps_suppkey    bigint not null,
    ps_availqty   bigint not null,
    ps_supplycost double not null,
    ps_comment    String not null
)
    engine MergeTree() ORDER BY tuple();



CREATE TABLE tpch_notnull.supplier
(
    s_suppkey   bigint not null,
    s_name      String not null,
    s_address   String not null,
    s_nationkey bigint not null,
    s_phone     String not null,
    s_acctbal   double not null,
    s_comment   String not null
)
    engine MergeTree() ORDER BY tuple();