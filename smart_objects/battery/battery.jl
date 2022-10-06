json_settings = open("smart_objects/battery/settings.json")
settings_battery = Dict()
settings_battery = JSON.parse(read(json_settings, String))

battery_state = settings_battery["starting kwh"]
battery_state_list = []

function charge_battery(amount)
    global battery_state
    leftover_storage = settings_battery["capacity"] - battery_state
    if leftover_storage > (amount*settings_battery["charge efficiency"])
        battery_state += amount*settings_battery["charge efficiency"]
        return 0
    else
        battery_state += leftover_storage
        return amount - leftover_storage * (1/settings_battery["charge efficiency"])
    end
end

function discharge_battery(amount)
    global battery_state
    if battery_state > (-amount * (1/settings_battery["discharge efficiency"]))
        battery_state += amount * (1/settings_battery["discharge efficiency"])
        return 0
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
    if input > settings_battery["grid charge power"]
        output = charge_battery(input)
    elseif input < settings_battery["grid discharge power"]
        output = discharge_battery(input)
    end
    append!(battery_state_list, battery_state)
    return output
end

function reset_battery()
    global battery_state
    global battery_state_list
    battery_state = settings_battery["starting kwh"]
    battery_state_list = [] 
end