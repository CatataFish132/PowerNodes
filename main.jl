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
include("smart_objects/battery/battery.jl")

function Calculate()
    objects = collect(values(object_dict))
    objects_matrix = mapreduce(permutedims, vcat, objects)
    output = []
    for i in eachindex(objects_matrix[1,:])
        append!(output, sum(objects_matrix[:,i]))
        output[i] = battery_input(output[i])
    end
    return output
end

results = Calculate()
# plot(results)
plot(battery_state_list)