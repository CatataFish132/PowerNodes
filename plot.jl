function plot_data(path, data, name="", xaxis="Time (Hours)", yaxis="Power (Kwh/h)")
    plot(vec(data), title=name*" Year", xaxis=xaxis, yaxis=yaxis, legend=false, dpi=250)
    savefig(path*"/output_year.png")

    plot(vec(data[1:(24*31)]), title=name*" Month", xaxis=xaxis, yaxis=yaxis, legend=false, dpi=250)
    savefig(path*"/output_month.png")

    plot(vec(data[1:(24*7)]), title=name*" Week", xaxis=xaxis, yaxis=yaxis, legend=false, dpi=250)
    savefig(path*"/output_week.png")

    plot(vec(data[1:(24)]), title=name*" Day", xaxis=xaxis, yaxis=yaxis, legend=false, dpi=250)
    savefig(path*"/output_day.png")
end