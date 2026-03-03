# TRACE Lab Walking Analysis

This project uses MATLAB. The scripts take force data and torque data from AnyBody files (.h5). We look at walking with a helper rod. We use this data to help program humanoid robots.

## Folders

* `/`: The MATLAB scripts stay here.
* `/data_csv/`: The scripts put data files (.csv) here.
* `/figures/`: The scripts put plots (.png) here.
* `/reports/`: The scripts put text reports (.txt) here.

## Setup

Need the data files to run data analysis. The files are from the inverse dynamics simulation on AnyBody:
* `GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5`
* `GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_MarkerTracking.anydata.h5`

## Steps

**Step 1: Get Data**
* Run `run_analysis.m` to extract leg data.
* Run `run_hand.m` to extract arm data.

**Step 2: Make Plots**
* Run `plot_results.m` to graph leg data and write a leg report.
* Run `plot_hand.m` to graph arm data and write an arm report.

## Notes

1. On the weight loading of the right hand: 
The human model's right wrist has a peak vertical load of about 145 N, which is roughly 15 kg of downward force pushing into the helper rod. This shows that during the walking cycle, a good amount of the model's total body weight was shifted away from the lower body (the legs) and supported by the right arm instead.

2. On the loading of the right knee: 
Because the right arm was providing that extra support, the right knee only had to handle a peak vertical load of around 600 N. Compare that to the unassisted left knee, which absorbed over 1600 N during its stance phase. This asymmetry shows how the helper rod took the dynamic vertical weight off the assisted leg.

3. On the right knee torque: 
Shifting all an amount of vertical weight to the hand changes the effort it takes to take a step. Since the rod was bearing a good portion of the load, the model's right knee only needed to generate a minimal peak flexion torque of about 8 Nm. In contrast, the unassisted left knee had to support the body independently and generates nearly 23 Nm of torque.

4. On the body lateral shift mechanism: 
Relying on support from just one side with the helper rod also redirects a lot of force horizontally. The data show that a major lateral force hitting a peak of -800 N on the right ankle. This suggests that the model had to absorb great side-to-side forces to avoid tipping over while shifting weight onto the helper rod.
