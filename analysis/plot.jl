using Plots, CSV, DataFrames

actual4 = CSV.read("./four-layer.csv", DataFrame)
actual2 = CSV.read("./two-layer.csv", DataFrame)
ref = CSV.read("./response.csv", DataFrame)

dB(r, i) = dB(Complex(r, i))
dB(gain) = 20 * log10(abs(gain))

actual4[!,:gain] = dB.(actual4[!,:s12r], actual4[!,:s12c])
actual2[!,:gain] = dB.(actual2[!,:s12r], actual2[!,:s12c])

p = plot(log10.(ref[!,:frequency]./1e6), ref[!,:gain], label="Simulated")
plot!(p, log10.(actual2[!,:f]./1e6), actual2[!,:gain] .- dB(2), label="Two layer")
plot!(p, log10.(actual4[!,:f]./1e6), actual4[!,:gain] .- dB(2), label="Two layer")

fx = vec([i*10^j for i in [1,2,5], j in 0:8])
ticks = (log10.(fx./1e6), string.(Int.(round.(fx ./ 1e6))))
plot!(p, ylim=(-100,0), xlim=(1,log10(300)), xticks=ticks)
plot!(p, xlab="Frequency (MHz)\n", ylab="\nS12 (dB)")

png(p, "measured.png")
     
