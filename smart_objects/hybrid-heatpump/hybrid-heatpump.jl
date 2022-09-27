json_settings = open("smart_objects/hybrid-heatpump/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("smart_objects/hybrid-heatpump/data.csv")))

