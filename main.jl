using CSV
using DataFrames
using JSON
using Plots
using BenchmarkTools
using QuadGK

electricity = Dict()
heat = Dict()

include("objects/wind_big/wind_big.jl")
include("objects/wind_small/wind_small.jl")
include("objects/solar/solar.jl")
# include("objects/ecar/ecar.jl")
include("objects/demand/demand.jl")
# include("smart_objects/battery/battery.jl")
include("smart_objects/curtailment/curtailment.jl")
include("smart_objects/smart_ecar/smart_ecar.jl")

# HEAT
include("objects/heat_demand/heat_demand.jl")
include("smart_objects/ecovat/ecovat.jl")
include("objects/solar_collectors/solar_collectors.jl")
include("smart_objects/smart_heatpump/smart_heatpump.jl")

function Calculate()
    electricity_list = collect(values(electricity))
    electricity_matrix = mapreduce(permutedims, vcat, electricity_list)

    heat_list = collect(values(heat))
    heat_matrix = mapreduce(permutedims, vcat, heat_list)

    output = []
    output_heat = []
    for i in eachindex(electricity_matrix[1,:])
        append!(output, sum(electricity_matrix[:,i]))
        append!(output_heat, sum(heat_matrix[:,i]))
        # output[i] = battery_input(output[i])
        output[i] = input_ecar(output[i], i)
        output[i] = input_smart_heatpump(output[i], i)
        output[i] = input_curtailment(output[i])

        output_heat[i] = input_ecovat(output_heat[i])
    end
    return output, output_heat
end

results = Calculate()
# plot(results[2])
plot(results[1])

plot(car_battery_list/maximum(car_battery_list)*100)

# plot(ecovat_state_list/3700000)
# plot(reverse(sort(results[1])))
# plot(battery_state_list)