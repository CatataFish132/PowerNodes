json_settings = open("objects/wind_small/settings.json")
settings_wind_small = Dict()
settings_wind_small = JSON.parse(read(json_settings, String))

function generate_wind_small(settings)
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
    return wind_power_small*settings["amount"]
end

wind_power_small = generate_wind_small(settings_wind_small)
plot_data("objects/wind_small", wind_power_small)