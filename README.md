# QuadMat

Some MATLAB scripts for a drone simulation, can be used via script or simulink.

## Features

* Open loop simulation for a quadcopter model using the space state equations and ode45.
* Plot of X,Y,Z axis values and the drone angles (ϕ, θ, ψ).
* Simulink blocks for the model.
* Simple PID implementation on the **height** and **atitude** control.
* Genetic being used for **height** control.

## TODO

* Use GA to optimize PID gains for the **atitude** control.
* Develop CACM method.
* Get the lookup table for the controled height loop.