json_settings = open("smart_objects/ecovat/settings.json")
settings_ecovat = Dict()
settings_ecovat = JSON.parse(read(json_settings, String))

ecovat_state = settings_ecovat["start"]
ecovat_state_list = []

function charge_ecovat(input)
    global ecovat_state
    output = 0
    ecovat_state += input * settings_ecovat["efficiency"]^-1
    if ecovat_state > settings_ecovat["capacity"]
        output = ecovat_state - settings_ecovat["capacity"]
        ecovat_state = settings_ecovat["capacity"]
    end
    return output
end

function discharge_ecovat(input)
    global ecovat_state
    output = 0
    ecovat_state += input * settings_ecovat["efficiency"]^-1
    if ecovat_state < 0
        output = ecovat_state
        ecovat_state = 0
    end
    return output
end

function input_ecovat(input)
    append!(ecovat_state_list, ecovat_state)
    output = input
    if input > 0
        output = charge_ecovat(input)
    elseif input < 0
        output = discharge_ecovat(input)
    end
    return output
end

function ecovat_diff()
    global ecovat_state
    return settings_ecovat["capacity"] - ecovat_state
end