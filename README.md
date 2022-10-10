# getting started

## Installing Julia

Download and install [julia](https://julialang.org/downloads/)

## installing dependencies method #1

In the terminal/commandline type julia and press enter. The julia prompt should now appear. Press the `]` key to go to the package manager. now type in `activate .`to activate the current project and type in`instantiate` to install all the packages.

## installing dependencies method #2

In the terminal/commandline type julia and press enter. The julia prompt should now appear.

type this statement to install all the dependencies

`using Pkg; Pkg.add("CSV"); Pkg.add("JSON"); Pkg.add("DataFrames"); Pkg.add("Plots")`

## running the model

first you need to go back to the julia prompt by pressing `ctr+c`. Then you can run the model by typing `include("main.jl")`.

# Editing the model

To edit the model you can eddit the settings.json files that are in each folder that represents an object. After you have edited the settings.json you can just rerun the model and it will use the values inside the settings.json file. the objects in the objects folder are dumb and they just generate or take energy without considering any other factors while the objects in the smart_objects folder are as the name implies smart. They look at other variables to determine their behaviour.

# Plotting

Plotting can be done via the Plots package. More info about it can be found [here](https://docs.juliaplots.org/stable/)