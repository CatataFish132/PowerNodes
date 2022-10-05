json_settings = open("objects/solar_collectors/settings.json")
settings_solar_collectors = Dict()
settings_solar_collectors = JSON.parse(read(json_settings, String))

function generate_solar_collectors(settings)
    data = DataFrame(CSV.File(open("objects/solar_collectors/data.csv")))
    solar_data = data[!, "solar"]
    solar_data = solar_data/1000
    solar_collectors_data = solar_data * settings["surface area"] * settings["amount"] * settings["efficiency"]
    heat["solar collectors"] = solar_collectors_data
    return solar_collectors_data
end

solar_collectors_data = generate_solar_collectors(settings_solar_collectors)
plot_data("objects/solar_collectors", solar_collectors_data)