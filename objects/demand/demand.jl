json_settings = open("objects/demand/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("objects/demand/data.csv")))

demand = (data[!, "demand"] / 7700) * settings["houses"]
object_dict["demand"] = demand

df = DataFrame(demand_output=vec(demand))
CSV.write("objects/demand/output.csv", df)

plot(vec(demand))
savefig("objects/demand/output_year.png")

plot(vec(demand[1:(24*31)]))
savefig("objects/demand/output_month.png")

plot(vec(demand[1:(24*7)]))
savefig("objects/demand/output_week.png")

plot(vec(demand[1:(24)]))
savefig("objects/demand/output_day.png")