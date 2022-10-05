function plot_data(path, data)
    plot(vec(data))
    savefig(path*"/output_year.png")

    plot(vec(data[1:(24*31)]))
    savefig(path*"/output_month.png")

    plot(vec(data[1:(24*7)]))
    savefig(path*"/output_week.png")

    plot(vec(data[1:(24)]))
    savefig(path*"/output_day.png")
end