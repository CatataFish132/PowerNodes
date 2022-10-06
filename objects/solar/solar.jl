# solar
json_settings = open("objects/solar/settings.json")
settings_solar = Dict()
settings_solar = JSON.parse(read(json_settings, String))

function generate_solar(settings)
    data = DataFrame(CSV.File(open("objects/solar/data.csv")))
    solar_data = data[!, "solar"]

    solar_panel_data = map(x -> min((x*settings["efficiency"]*settings["efficiency inverters"]*settings["surface area"])/1000, settings["power output"]/1000), solar_data)

    solar = solar_panel_data * settings["amount"]
    electricity["solar"] = solar
    return solar
end

solar = generate_solar(settings_solar)
plot_data("objects/solar", solar, "Solar Generation")

df = DataFrame(solar_output=vec(solar))
CSV.write("objects/solar/output.csv", df)
