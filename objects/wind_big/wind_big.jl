json_settings = open("objects/wind_big/settings.json")
settings_wind_big = Dict()
settings_wind_big = JSON.parse(read(json_settings, String))

function generate_wind_big(settings)
    data = DataFrame(CSV.File(open("objects/wind_big/data.csv")))
    wind_speed = data[!, "wind_speed"]

    wind_corrected = wind_speed * log(settings["height turbine"]/settings["roughness location"])/log(settings["height measurement"]/settings["roughness location"])

    wind_power = []
    for i in eachindex(wind_corrected)
        if wind_corrected[i] < settings["cut-in speed"]
            power = 0
        elseif wind_corrected[i] <= settings["rated speed"]
            power = (0.0194*wind_corrected[i]^6-1.0524*wind_corrected[i]^5+22.65*wind_corrected[i]^4-249.22*wind_corrected[i]^3+1502.1*wind_corrected[i]^2-4593.8*wind_corrected[i]+5492.5)
        elseif wind_corrected[i] <= settings["cut-off speed"]
            power = settings["power output"]/1000
        else
            power = 0
        end
        power = power * settings["efficiency"] * settings["efficiency reformers"]
        append!(wind_power, power)
    end

    electricity["wind-big"] = wind_power*settings["amount"]
    return wind_power*settings["amount"]
end

wing_power_big = generate_wind_big(settings_wind_big)
plot_data("objects/wind_big", wing_power_big, "Wind-big Generation")
# df = DataFrame(wind_big_output=vec(wind_power), corrected_wind_speed=vec(wind_corrected))
# CSV.write("objects/wind_big/output.csv", df)
