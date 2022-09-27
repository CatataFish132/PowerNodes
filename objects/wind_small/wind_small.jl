json_settings = open("objects/wind_small/settings.json")
settings = Dict()
settings = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("objects/wind_small/data.csv")))
wind_speed = data[!, "wind_speed"]


wind_corrected = wind_speed * log(settings["height turbine"]/settings["roughness location"])/log(settings["height measurement"]/settings["roughness location"])

wind_power_small = []
for i in eachindex(wind_corrected)
    if wind_corrected[i] < settings["cut-in speed"]
        power = 0
    elseif wind_corrected[i] <= settings["rated speed"]
        power = ((-4.7786*wind_corrected[i]^4+144.52*wind_corrected[i]^3-1481.8*wind_corrected[i]^2+7037.1*wind_corrected[i]-10350)/1000*(15/10))
    elseif wind_corrected[i] <= settings["cut-off speed"]
        power = settings["power output"]/1000
    else
        power = 0
    end
    power = power * settings["efficiency"] * settings["efficiency reformers"]
    append!(wind_power_small, power)
end

electricity["wind-small"] = wind_power_small*settings["amount"]

df = DataFrame(wind_small_output=vec(wind_power_small), corrected_wind_speed=vec(wind_corrected))
CSV.write("objects/wind_small/output.csv", df)

plot(vec(wind_power_small))
savefig("objects/wind_small/output_year.png")

plot(vec(wind_power_small[1:(24*31)]))
savefig("objects/wind_small/output_month.png")

plot(vec(wind_power_small[1:(24*7)]))
savefig("objects/wind_small/output_week.png")

plot(vec(wind_power_small[1:(24)]))
savefig("objects/wind_small/output_day.png")