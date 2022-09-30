json_settings = open("smart_objects/smart_ecar/settings.json")
settings_ecar = Dict()
settings_ecar = JSON.parse(read(json_settings, String))

car_battery_state = settings_ecar["capacity per car"] * settings_ecar["amount of cars"]
car_battery_list = []
function input_ecar(e, i)
    global car_battery_list
    global car_battery_state
    append!(car_battery_list, car_battery_state)
    time = i % 24
    if i % 24 == 16
        car_battery_state += settings_ecar["energy per car per day"] * settings_ecar["amount of cars"]
    end
    if ( time < settings_ecar["stop charging time"] || time > settings_ecar["start charging time"] )
        if e > settings_ecar["grid target level"]
            return charge_ecar(e)
        elseif car_battery_state/(settings_ecar["capacity per car"] * settings_ecar["amount of cars"]) < 0.6
            return force_charge_ecar(e)
        end
    end
    return e
end

function charge_ecar(amount)
    global car_battery_state
    leftover_storage = settings_ecar["capacity per car"]*settings_ecar["amount of cars"] - car_battery_state
    diff = amount - settings_ecar["grid target level"]
    if leftover_storage > (diff*settings_ecar["charging efficiency"])
        car_battery_state += diff*settings_ecar["charging efficiency"]
        return amount - diff
    else
        car_battery_state += leftover_storage
        return amount - leftover_storage * (1/settings_ecar["charging efficiency"])
    end
end

function force_charge_ecar(amount)
    global car_battery_state
    leftover_storage = settings_ecar["capacity per car"]*settings_ecar["amount of cars"] - car_battery_state
    diff = amount - settings_ecar["grid min level"]
    if leftover_storage > (diff*settings_ecar["charging efficiency"])
        car_battery_state += diff*settings_ecar["charging efficiency"]
        return amount - diff
    else
        car_battery_state += leftover_storage
        return amount - leftover_storage * (1/settings_ecar["charging efficiency"])
    end
end 
