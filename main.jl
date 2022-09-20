using CSV
using DataFrames
using JSON
using Plots
using BenchmarkTools

data = DataFrame(CSV.File(open("data.csv")))

demand = data[!, "demand"]
solar = data[!, "solar"]
wind_big = data[!, "wind_big"]
wind_small = data[!, "wind_small"]
ecar = data[!, "ecar"]

json_settings = open("settings.json")
dict = Dict()
dict=JSON.parse(read(json_settings, String))

output = []
battery_state = 332000
battery_state_list = []


function Calculate(dict)
    output = []
    battery_state = 332000
    battery_state_list = []
    for i in 1:8760
        global battery_state
        append!(output, ecar[i] + demand[i] + dict["solar panels"]*solar[i] + dict["wind big"]*wind_big[i] + dict["wind small"]*wind_small[i])

        # Battery Charging Logic
        if output[i] > dict["battery"]["grid charge power"]
            if (dict["battery"]["capacity"] - battery_state) > output[i]
                battery_state += output[i]
                output[i] = 0
            else
                output[i] += battery_state - dict["battery"]["capacity"]
                battery_state += dict["battery"]["capacity"] - battery_state
            end
        end

        # Battery Discharging Logic
        if output[i] < dict["battery"]["grid discharge power"]
            diff = output[i]-dict["battery"]["grid discharge power"]
            if abs(diff) < battery_state
                battery_state += diff
                output[i] -= diff
            else
                output[i] - battery_state
                battery_state = 0
            end
        end
            

        append!(battery_state_list, battery_state)
    end

    return battery_state_list, output
end

# plot(Calculate()[1]/dict["battery"]["capacity"]*100)
# plot(Calculate()[2])

passed = []
function check(dict)
    global passed
    fail = false
    results = Calculate(dict)
    for k in results[2]
        if abs(k) > 10000
            fail = true
            break
        end
    end
    if fail
        println("fail")
    else
        println("its gud")
        append!(passed, dict)
    end
end


for solar_panels in 0:10000:100000
    for wind_big in 0:20
        for wind_small in 0:100:1000
            for capacity in 0:10000:300000
                dict["solar panels"] = solar_panels
                dict["wind big"] = wind_big
                dict["wind small"] = wind_small
                dict["battery"]["capacity"] = capacity
                check(dict)
            end
        end
    end
end


println(passed)