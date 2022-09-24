# solar
json_settings = open("objects/solar/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("objects/solar/data.csv")))
solar_data = data[!, "solar"]

solar_panel_data = map(x -> min((x*settings["efficiency"]*settings["efficiency inverters"]*settings["surface area"])/1000, settings["power output"]/1000), solar_data)

solar = solar_panel_data * settings["amount"]
object_dict["solar"] = solar

df = DataFrame(solar_output=vec(solar))
CSV.write("objects/solar/output.csv", df)

plot(vec(solar))
savefig("objects/solar/output_year.png")

plot(vec(solar[1:(24*31)]))
savefig("objects/solar/output_month.png")

plot(vec(solar[1:(24*7)]))
savefig("objects/solar/output_week.png")

plot(vec(solar[1:(24)]))
savefig("objects/solar/output_day.png")