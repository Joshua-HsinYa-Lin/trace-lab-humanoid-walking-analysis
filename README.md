# TRACE Lab Walking Analysis


This project uses MATLAB to extract and analyze biomechanical force and torque data from AnyBody simulation files (.h5). The primary goal is to analyze human interaction forces during a walking task where a helper assists a follower. By evaluating lateral stabilization, vertical weight, and ground reaction forces (GRF), we also compare assisted walking against unassisted single person walking to validate the integrity of the motion capture marker data. We establish physical baselines to train humanoid robots for physical walking assistance. 

## Terminology Guide



[Image of anatomical planes and directions of the human body]


Because AnyBody exports data using anatomical reference frames, here is a simple translation guide for the variables used in the plots and reports.

**The Actors**
* **Follower:** The human model receiving assistance and leaning on the rod.
* **Helper:** The human model providing support.
* **Helper Right / Helper Left:** The specific arm of the Helper being analyzed.

**Wrist Forces (Arm Data)**



* **ProximoDistal Force (Vertical Lift):** Force traveling along the length of the arm. In this walking task, this represents the Up/Down weight bearing force holding the Follower up.
* **DorsoVolar Force (Push/Pull):** Force traveling from the back of the hand through the palm. This represents the Forward/Backward forces of pacing and towing the Follower.
* **Radial Force (Lateral Balance):** Force traveling side to side across the wrist joint. This represents the Left/Right stabilization preventing the Follower from tipping over.

**Ankle Forces (Leg Data)**
* **ProximoDistal Force:** The vertical force traveling up the leg from the ground.
* **AnteroPosterior Force:** The forward and backward braking and accelerating forces during a footstep.
* **MedioLateral Force:** The side to side balancing forces on the ankle.

## Folders

* `/`: The MATLAB scripts stay here.
* `/data_csv/`: The scripts put extracted force and moment data files (.csv) here.
* `/figures/`: The scripts put generated interaction plots (.png) here.
* `/reports/`: The scripts put text summaries and joint force reports (.txt) here.

## Setup

Place the following AnyBody inverse dynamics simulation files in the root directory to run the analysis:

* `GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_InverseDynamicStudy.anydata.h5`
* `GRF_FullBody_IC_walker_WL_helper_ground_walk_w_rod_03_MarkerTracking.anydata.h5`
* `FullBody_IC_walk_01_InverseDynamicStudy.anydata.h5`

## Steps

**Step 1: Get Data**
* Run `run_analysis.m` to extract the helper leg data.
* Run `run_hand.m` to extract the helper arm data.
* Run `run_follower.m` to extract the follower hand interaction data.
* Run `run_GRF.m` to extract the ground reaction forces for the foot plates.
* Run `run_single_hand.m` and `run_single_leg.m` to extract the baseline single person data.

**Step 2: Make Plots and Reports**
* Run `plot_results.m` to graph leg data and write the leg report.
* Run `plot_hand.m` to graph arm data and write the arm report.
* Run `plot_follower.m` to overlay follower forces against the helper hands.
* Run `plot_GRF.m` to compare external ground forces against internal ankle joint loads.
* Run `plot_single.m` to identify abnormal force spikes by comparing the interaction model to the single person baseline.

## Notes

1. On the validity of interaction forces:
The interaction data shows extreme lateral forces of over 350 N and vertical loads of 145 N on the helper arm. While this force is within human's capability, it is very high and it is unlikely for human to sustain it over an entire experimental period. This abnormality suggests that the motion capture markers from the two individuals might potentially be mixed up during the recording, causing the simulation to combine both people's movements and weights into a single person.

2. On the ground reaction force predictions:
The ground reaction forces predicted by the simulation agrees with the internal leg joint forces extracted from the human model. The data shows a clear relationship and gap between the GRF and the internal ankle loading. This physical alignment proves that the underlying physics engine of the simulation is calculating correctly and producing valid biomechanical results.

3. On the comparison with the single person walk:
The assisted interaction model showed massive force spikes in the right arm and the unassisted single person model didn't. Because the single person was not holding a heavy payload or a helper rod during their walk, their arm forces should naturally be near zero, while the assisted helper should have force spikes because of the interaction forces. This suggests that the general force fluctuations simulated by AnyBody might be correct but the magnitude is questionable.

4. On the weight loading of the right hand: 
The human model's right wrist has a peak vertical load of about 145 N, which is roughly 15 kg of downward force pushing into the helper rod. This shows that during the walking cycle, a good amount of the model's total body weight was shifted away from the lower body (the legs) and supported by the right arm instead.

5. On the loading of the right knee: 
Because the right arm was providing that extra support, the right knee only had to handle a peak vertical load of around 600 N. Compare that to the unassisted left knee, which absorbed over 1600 N during its stance phase. This asymmetry shows how the helper rod took the dynamic vertical weight off the assisted leg.

6. On the right knee torque: 
Shifting all an amount of vertical weight to the hand changes the effort it takes to take a step. Since the rod was bearing a good portion of the load, the model's right knee only needed to generate a minimal peak flexion torque of about 8 Nm. In contrast, the unassisted left knee had to support the body independently and generates nearly 23 Nm of torque.

7. On the body lateral shift mechanism: 
Relying on support from just one side with the helper rod also redirects a lot of force horizontally. The data show that a major lateral force hitting a peak of -800 N on the right ankle. This suggests that the model had to absorb great side-to-side forces to avoid tipping over while shifting weight onto the helper rod.