json_settings = open("objects/heat_demand/settings.json")
settings_heat_demand = Dict()
settings_heat_demand = JSON.parse(read(json_settings, String))

function generate_heat_demand(settings)
    
    data = DataFrame(CSV.File(open("objects/heat_demand/data.csv")))
    heat_demand = data[!, "heat_demand"]

    heat_demand_total = -heat_demand * settings["total demand"]

    heat["demand"] = heat_demand_total * (1-settings["insulation"])
    return heat_demand_total
end

heat_demand_total = generate_heat_demand(settings_heat_demand)
plot_data("objects/heat_demand", heat_demand_total)