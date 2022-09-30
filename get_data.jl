using XLSX
using CSV
using DataFrames

xf = XLSX.readxlsx("data.xlsm")

# ## SOLAR
solar_pv = xf["Solar PV"]
# solar_pv_data = solar_pv["AK4:AK8763"]
solar_data = solar_pv["AJ4:AJ8763"]


## WIND Big
wind_big = xf["Wind"]
# wind_big_data = wind_big["AL4:AL8763"]

wind_speed = wind_big["AJ4:AJ8763"]

temperature = xf["Electric heat pump"]
temp_data = temperature["AJ4:AJ8763"]

heat = xf["DEMAND"]
heat_demand_data = heat["AY4:AY8763"]

temp = xf["Electric heat pump"]
temp_data = temp["AJ4:AJ8763"]

# wind_small = xf["Wind Small"]
# wind_small_data = wind_small["AL4:AL8763"]

# demand = xf["DEMAND"]
# demand_data = demand["AU4:AU8763"]

# ecar = xf["E-CAR"]
# ecar_data = ecar["AK4:AK8763"]

# heat_pumps = xf["Electric heat pump"]
# heat_pumps_data = heat_pumps["AS4:AS8763"]

df = DataFrame(temperature=vec(temp_data))
CSV.write("smart_objects/smart_heatpump/data.csv", df)
