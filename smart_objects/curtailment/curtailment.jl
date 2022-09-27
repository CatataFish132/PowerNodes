json_settings = open("smart_objects/curtailment/settings.json")
settings_curtailment = Dict()
settings_curtailment = JSON.parse(read(json_settings, String))

function input_curtailment(e)
    if e > settings_curtailment["curtailment level"]
        return e = settings_curtailment["curtailment level"]
    else
        return e
    end
end