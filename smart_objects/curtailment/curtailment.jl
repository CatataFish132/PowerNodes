json_settings = open("smart_objects/curtailment/settings.json")
settings_curtailment = Dict()
settings_curtailment = JSON.parse(read(json_settings, String))

curtailment_list = []
function input_curtailment(e)
    if e > settings_curtailment["curtailment level"]
        append!(curtailment_list, (e - settings_curtailment["curtailment level"]))
        return e = settings_curtailment["curtailment level"]
    else
        append!(curtailment_list, 0.0)
        return e
    end
end