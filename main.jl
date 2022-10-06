using CSV
using DataFrames
using JSON
using Plots

electricity = Dict()
heat = Dict()
smart_systems = Dict()
smart_systems["ecar"] = []
smart_systems["heatpump"] = []
smart_systems["battery"] = []
smart_systems["ecovat"] = []

include("plot.jl")
include("objects/wind_big/wind_big.jl")
include("objects/wind_small/wind_small.jl")
include("objects/solar/solar.jl")
include("objects/demand/demand.jl")
include("smart_objects/battery/battery.jl")
include("smart_objects/curtailment/curtailment.jl")
include("smart_objects/smart_ecar/smart_ecar.jl")

# HEAT
include("objects/heat_demand/heat_demand.jl")
include("smart_objects/ecovat/ecovat.jl")
include("smart_objects/smart_heatpump/smart_heatpump.jl")

function Calculate()
    global heat_matrix
    electricity_list = collect(values(electricity))
    electricity_matrix = mapreduce(permutedims, vcat, electricity_list)

    heat_list = collect(values(heat))
    heat_matrix = mapreduce(permutedims, vcat, heat_list)

    output = []
    output_heat = []
    for i in eachindex(electricity_matrix[1,:])
        append!(output, sum(electricity_matrix[:,i]))
        append!(output_heat, sum(heat_matrix[:,i]))
        e = output[i]
        output[i] = input_ecar(output[i], i)
        append!(smart_systems["ecar"], output[i] - e)
        e = output[i]
        output[i] = input_smart_heatpump(output[i], i)
        append!(smart_systems["heatpump"], output[i] - e)
        e = output[i]
        output[i] = battery_input(output[i])
        append!(smart_systems["battery"], output[i] - e)
        
        output[i] = input_curtailment(output[i])

        e = output_heat[i]
        output_heat[i] = input_ecovat(output_heat[i])
        append!(smart_systems["ecovat"], output_heat[i] - e)
    end
    return output, output_heat
end

results = Calculate()

plot(results[1], size=(1000, 400), xaxis="Time (Hours)", yaxis="Power (Kwh/h)", margin=4.0*Plots.mm, legend=false, dpi=300, title="NET LOAD SIGNAL")
savefig("output/output_year.png")

plot(car_battery_list/(settings_ecar["capacity per car"]*settings_ecar["amount of cars"])*100, size=(1000, 400), xaxis="Time (Hours)", yaxis="Car Battery %", margin=4.0*Plots.mm, legend=false, dpi=300, title="Car Battery")
savefig("output/output_car_battery.png")

plot(ecovat_state_list/settings_ecovat["capacity"]*100, size=(1000, 400), xaxis="Time (Hours)", yaxis="Ecovat %", margin=4.0*Plots.mm, legend=false, dpi=300, title="Ecovat")
savefig("output/output_ecovat_battery.png")

plot(reverse(sort(results[1])), size=(1000, 400), xaxis="Time (Hours)", yaxis="Power (Kwh/h)", margin=4.0*Plots.mm, legend=false, dpi=300, title="LOAD DEMAND CURVE")
savefig("output/output_load_demand_curve.png")

plot(battery_state_list/settings_battery["capacity"]*100, size=(1000, 400), xaxis="Time (Hours)", yaxis="Battery %", margin=4.0*Plots.mm, legend=false, dpi=300, title="Battery")
savefig("output/output_battery.png")

println(" * Sum of electricity: ", sum(results[1]))
println(" * Abs sum of electricity: ", sum(abs.(results[1])))
println(" * Total electricity generated: ", sum([sum(electricity["solar"]), sum(electricity["wind-small"]), sum(electricity["wind-big"])]))
println(" * Percentage generated electricity direct usage: ", (1-(sum(abs.(results[1]))/(sum([sum(electricity["solar"]), sum(electricity["wind-small"]), sum(electricity["wind-big"])]))))*100, "%")