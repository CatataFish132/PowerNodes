json_settings = open("objects/heat_demand/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("objects/heat_demand/data.csv")))
heat_demand = data[!, "heat_demand"]

heat_demand_total = -heat_demand * settings["total demand"]

heat["demand"] = heat_demand_total * (1-settings["insulation"])