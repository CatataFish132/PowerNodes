# for i in 1:8760
    #     append!(output, sum(values(object_dict)))

    #     # Battery Charging Logic
    #     if output[i] > dict["battery"]["grid charge power"]
    #         if (dict["battery"]["capacity"] - battery_state) > output[i]
    #             battery_state += output[i]
    #             output[i] = 0
    #         else
    #             output[i] += battery_state - dict["battery"]["capacity"]
    #             battery_state += dict["battery"]["capacity"] - battery_state
    #         end
    #     end

    #     # Battery Discharging Logic
    #     if output[i] < dict["battery"]["grid discharge power"]
    #         diff = output[i]-dict["battery"]["grid discharge power"]
    #         if abs(diff) < battery_state
    #             battery_state += diff
    #             output[i] -= diff
    #         else
    #             output[i] - battery_state
    #             battery_state = 0
    #         end
    #     end
            

    #     append!(battery_state_list, battery_state)
    # end