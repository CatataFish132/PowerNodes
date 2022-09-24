using Plots
using DataFrames
using CSV 

data = DataFrame(CSV.File(open("data.csv")))

demand = data[!, "demand"]
solar = data[!, "solar"]
wind_big = data[!, "wind_big"]
wind_small = data[!, "wind_small"]
ecar = data[!, "ecar"]
heatpump = data[!, "heatpump"]

# plot(solar[1:168])
# plot!(solar[4320:(4320+168)])
plot(heatpump[1:24]*-1)