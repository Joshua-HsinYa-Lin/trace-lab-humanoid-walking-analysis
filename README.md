# TRACE Lab Walking Analysis

This project uses MATLAB. The scripts take force data and torque data from AnyBody files (.h5). We look at walking with a helper rod. We use this data to build a robot.

## Folders

* `/`: The MATLAB scripts stay here.
* `/data_csv/`: The scripts put data files (.csv) here.
* `/figures/`: The scripts put plots (.png) here.
* `/reports/`: The scripts put text reports (.txt) here.

## Setup

You need MATLAB. 

You need the data files. The files are not on GitHub. Get these files from the lab and put them in the root folder:
* `GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5`
* `GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_MarkerTracking.anydata.h5`

## Steps to Use

**Step 1: Get Data**
* Run `run_analysis.m` to extract leg data.
* Run `run_hand.m` to extract arm data.

**Step 2: Make Plots**
* Run `plot_results.m` to graph leg data and write a leg report.
* Run `plot_hand.m` to graph arm data and write an arm report.

## Notes

We look at how force moves between the arm and the leg. Read `human_report.txt` in the reports folder to see the results.

1. The Hand's Contribution: The human model's right wrist took on a peak vertical load of about 145 N. This shows that during the walking cycle, a chunk of the model's body weight shifted to the right arm.

2. The Knee's Reaction: Because the right arm gave support, the right knee handled a peak vertical load of around 600 N. The unassisted left knee absorbed over 1600 N. The helper rod took the weight off the leg.

3. The Torque Drop: Moving weight to the hand changes the effort to take a step. The model's right knee generated a peak torque of about 8 Nm. The unassisted left knee generated nearly 23 Nm of torque.

4. The Lateral Shift: Using support on one side moves force sideways. The right ankle had a lateral force peak of -800 N. The model absorbed side-to-side forces to keep from tipping.
