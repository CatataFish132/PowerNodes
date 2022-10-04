json_settings = open("smart_objects/smart_heatpump/settings.json")
settings_smart_heatpump = Dict()
settings_smart_heatpump = JSON.parse(read(json_settings, String))

data = DataFrame(CSV.File(open("smart_objects/smart_heatpump/data.csv")))
temperature = data[!, "temperature"]
if settings_smart_heatpump["geo"]
    temperature_k = zeros(length(temperature)).+(15+273)
else
    temperature_k = temperature .+ 273
end

temp_w_k = settings_smart_heatpump["temperature of water"]+273
temp_diff = (temp_w_k) .- temperature_k

performance = (temp_w_k./temp_diff).*settings_smart_heatpump["carnot factor"]

function input_smart_heatpump(e, i)
    diff = ecovat_diff()
    available_e = e - settings_smart_heatpump["target grid level"]
    if available_e > settings_smart_heatpump["max draw"]
        draw = settings_smart_heatpump["max draw"]
    else
        draw = available_e
    end

    if available_e > 0
        if diff > performance[i]*draw
            charge_ecovat(performance[i]*draw)
            return e - draw
        else
            charge_ecovat(diff)
            return e - (diff/performance[i])
        end
    end
    if ecovat_state/settings_ecovat["capacity"]<0.4
        draw = e - settings_smart_heatpump["min grid level"]
        if draw > settings_smart_heatpump["max draw"]
            draw = settings_smart_heatpump["max draw"]
        end
        if diff > performance[i]*draw
            charge_ecovat(performance[i]*draw)
            return e - draw
        else
            charge_ecovat(diff)
            return e - (diff/performance[i])
        end
    end
    return e

end
