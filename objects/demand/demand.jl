json_settings = open("objects/demand/settings.json")
settings_demand = Dict()
settings_demand = JSON.parse(read(json_settings, String))

function generate_demand(settings)
    data = DataFrame(CSV.File(open("objects/demand/data.csv")))

    demand = (data[!, "demand"] / 7700) * settings["houses"]
    electricity["demand"] = demand

    df = DataFrame(demand_output=vec(demand))
    CSV.write("objects/demand/output.csv", df)

    return demand
end

demand = generate_demand(settings_demand)
plot_data("objects/demand", vec(demand), "Demand")