
using Docile
using JavaCall
using Iterators

JJavaSparkContext = @jimport org.apache.spark.api.java.JavaSparkContext
JJavaRDD = @jimport org.apache.spark.api.java.JavaRDD
JJuliaRDD = @jimport org.apache.spark.api.julia.JuliaRDD


include("init.jl")
include("serialization.jl")
include("context.jl")
include("rdd.jl")
include("worker.jl")


# example function on partition iterator
@everywhere function take3(idx, it)
    println("Processing partition: $idx")
    return take(it, 3)
end

function demo()
    sc = SparkContext()
    java_rdd = text_file(sc, "file:///var/log/syslog")
    rdd = PipelinedRDD(java_rdd, take3)
    arr = collect(rdd)
    rdd2 = map_partitions_with_index(rdd, take3)
    arr2 = collect(rdd2)
end
