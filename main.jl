using CSV
using DataFrames
using JSON
using Plots
using BenchmarkTools
using QuadGK

object_dict = Dict()

include("objects/wind_big/wind_big.jl")
include("objects/wind_small/wind_small.jl")
include("objects/solar/solar.jl")
include("objects/ecar/ecar.jl")
include("objects/demand/demand.jl")

function Calculate()
    output = sum(values(object_dict))
    return output
end

results = Calculate()
plot(results)