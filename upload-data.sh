#!/bin/bash


clickhouse_client='/home/chang/OpenSource/ClickHouse/cmake-build-relwithdebinfo-clang15/programs/clickhouse client'
schema_file=schema/tpch_notnull.sql
scale=1
# echo "$clickhouse_client"

usage() {
    echo "Usage: $0 --db <db> [--schema <schema>]"
    echo "Run the TPC-H queries a number of times and report timings."
    echo ""
    echo "Options:"
    echo "  -d, --db <db>                     The imported database"
    echo "  -c, --schema <file>               Where to create schema default is tpch_notnull.sql"
    echo "  -s, --scale <number>              Scale 1 or 10 or 100, default = 1"
    echo "  -v, --verbose                     More output"
    echo "  -h, --help                        This message"
}



while [ "$#" -gt 0 ]
do
    case "$1" in
        -d|--db)
            dbname=$2
            shift
            shift
            ;;
        -c|--schema)
            schema_file=schema/$2
            shift
            shift
            ;;
        -s|--scale)
            scale=$2
            shift
            shift
            ;;            
        -v|--verbose)
            set -x
            set -v
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "$0: unknown argument $1"
            usage
            exit 1
            ;;
    esac
done

if [ -z "$dbname" ]; then
    usage
    exit 1
fi

if [ ! -f $schema_file ]; then
    echo "$schema_file not found!"
    exit 0
fi

$clickhouse_client --query="select version()"
$clickhouse_client --database="tpch_notnull" -mn < $schema_file

for file_name in `ls ./s${scale}/*.tbl`; do
    table_file=$(echo "${file_name##*/}")
    table_name=$(echo "${table_file%.*}" | tr '[:upper:]' '[:lower:]')
    upload_data_sql="INSERT INTO $table_name FORMAT CSV"

    echo "$upload_data_sql <-- $(du -h $file_name)"

    cat $file_name | ${clickhouse_client} --format_csv_delimiter="|" --max_partitions_per_insert_block=100 --database="${dbname}" --query="$upload_data_sql"
    # rm $file_name

    # sleep 5
done