json_settings = open("objects/ecar/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("objects/ecar/data.csv")))
ecar_data = data[!, "ecar"]

ecar = -ecar_data * settings["amount"] * settings["demand"]

electricity["ecar"] = ecar

df = DataFrame(ecar_output=vec(ecar))
CSV.write("objects/ecar/output.csv", df)

plot(vec(ecar))
savefig("objects/ecar/output_year.png")

plot(vec(ecar[1:(24*31)]))
savefig("objects/ecar/output_month.png")

plot(vec(ecar[1:(24*7)]))
savefig("objects/ecar/output_week.png")

plot(vec(ecar[1:(24)]))
savefig("objects/ecar/output_day.png")