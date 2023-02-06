#!/usr/bin/env bash


usage() {
    echo "Usage: $0 --db <db> [--number <repeats>] [--db <d>] [--output <file>]"
    echo "Run the TPC-H queries a number of times and report timings."
    echo ""
    echo "Options:"
    echo "  -d, --db <db>                     The database"
    echo "  -n, --number <repeats>            How many times to run the queries. Default=1"
    echo "  -o, --output <file>               Where to append the output. Default=timings.csv"
    echo "  -v, --verbose                     More output"
    echo "  -h, --help                        This message"
}

nruns=1


while [ "$#" -gt 0 ]
do
    case "$1" in
        -d|--db)
            dbname=$2
            shift
            shift
            ;;
        -n|--number)
            nruns=$2
            shift
            shift
            ;;
        -o|--output)
            nruns=$2
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

output="$dbname.timings.csv"

echo "# Database,Query,iter, thread, time" | tee -a "$output"


clickhouse_client='/home/chang/OpenSource/ClickHouse/cmake-build-relwithdebinfo-clang15/programs/clickhouse client'

run_allsqls() {
    max_thread=$1
    for j in $(seq 1 $nruns)
    do

        # max=0
        # min=9999999
        # sum=0
    
        for q in sql/*.sql
        do
            s=$(date +%s%N | cut -b1-13)
            timeout 3600s ${clickhouse_client} --max_threads ${max_thread} --optimize_move_to_prewhere 0 -n --queries-file $q -d $dbname > /dev/null 2>&1
            err=$?
        
            x=$(date +%s%N | cut -b1-13)
            elapsed=$(echo "scale=4; $x - $s" | bc) 
        
            # calculate max, min, avg
            # using bc cmps to have floating point precission
            # if [ $(echo "$elapsed > $max" | bc) -eq 1 ] 
            # then
            #     max=$elapsed
            # fi
        
            # if [ $(echo "$elapsed < $min" | bc) -eq 1 ]
            #     then
            #         min=$elapsed
            #     fi
        
            # sum=$(echo "$elapsed + $sum" | bc)
            echo "$dbname,"$(basename $q .sql)",$j,$max_thread,$elapsed" | tee -a "$output"
        done
    
        # avg=$(echo "scale=4; $sum/$nruns" | bc)
    
        # echo "$dbname,"$(basename $q .sql)",$min,$max,$avg,$err" | tee -a "$output"
    done

}


run_allsqls 1
run_allsqls 2
run_allsqls 4
run_allsqls 8
run_allsqls 16
