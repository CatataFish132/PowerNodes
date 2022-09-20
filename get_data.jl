using XLSX
using CSV
using DataFrames

xf = XLSX.readxlsx("data.xlsm")

solar_pv = xf["Solar PV"]
solar_pv_data = solar_pv["AK4:AK8763"]

wind_big = xf["Wind"]
wind_big_data = wind_big["AL4:AL8763"]

wind_small = xf["Wind Small"]
wind_small_data = wind_small["AL4:AL8763"]

demand = xf["DEMAND"]
demand_data = demand["AU4:AU8763"]

ecar = xf["E-CAR"]
ecar_data = ecar["AK4:AK8763"]*23100000

df = DataFrame(solar=vec(solar_pv_data), demand=vec(demand_data), wind_big=vec(wind_big_data), wind_small=vec(wind_small_data), ecar=vec(ecar_data))

CSV.write("data.csv", df)
