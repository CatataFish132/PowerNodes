json_settings = open("smart_objects/battery/settings.json")
settings_battery = Dict()
settings_battery = JSON.parse(read(json_settings, String))

battery_state = settings_battery["starting kwh"]
battery_state_list = []

function charge_battery(amount)
    global battery_state
    leftover_storage = settings_battery["capacity"] - battery_state
    diff = amount - settings_battery["target level"]
    if leftover_storage > (diff*settings_battery["charge efficiency"])
        battery_state += diff*settings_battery["charge efficiency"]
        return amount - diff
    else
        battery_state += leftover_storage
        return amount - leftover_storage * (1/settings_battery["charge efficiency"])
    end
end

function discharge_battery(amount)
    global battery_state
    diff = amount - settings_battery["target level"]
    if battery_state > (-diff * (1/settings_battery["discharge efficiency"]))
        battery_state += diff * (1/settings_battery["discharge efficiency"])
        return amount - diff
    else
        out = amount + battery_state * settings_battery["discharge efficiency"]
        battery_state = 0
        return out 
    end
end

function battery_input(input)
    global battery_state
    global battery_state_list
    battery_state -= battery_state * settings_battery["self discharge"]
    output = input
    if battery_state < settings_battery["capacity"] && output > settings_battery["target level"]
        output = charge_battery(input)
    elseif input < settings_battery["target level"]
        output = discharge_battery(input)
    end
    append!(battery_state_list, battery_state)
    return output
end