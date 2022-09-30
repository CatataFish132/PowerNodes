json_settings = open("objects/solar_collectors/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("objects/solar_collectors/data.csv")))
solar_data = data[!, "solar"]
solar_data = solar_data/1000

solar_collectors_data = solar_data * settings["surface area"] * settings["amount"] * settings["efficiency"]

heat["solar collectors"] = solar_collectors_data