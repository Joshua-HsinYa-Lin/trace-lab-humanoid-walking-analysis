# TRACE Lab Walking Analysis


This project uses MATLAB to extract and analyze biomechanical force and torque data from AnyBody simulation files (.h5). The primary goal is to analyze human interaction forces during a walking task where a helper assists a follower. By evaluating lateral stabilization, vertical weight, and ground reaction forces (GRF), we also compare assisted walking against unassisted single person walking to validate the integrity of the motion capture marker data. We establish physical baselines to train humanoid robots for physical walking assistance. 

## Terminology Guide



![Anatomical Planes and Directions](https://embryology.med.unsw.edu.au/embryology/images/0/04/Human-anatomical-planes.jpg)


AnyBody exports data using anatomical reference frames (as shown in the image), here is a simple guide for the variables used in the plots and reports.

**Actors**
* **Follower:** The human model receiving assistance and leaning on the rod.
* **Helper:** The human model providing support.
* **Helper Right / Helper Left:** The specific arm of the Helper being analyzed.

**Biomechanical Terms**
* **Flexion:** Bending a joint to decrease the angle between bones. For example, bending the knee or elbow during a walking stride.
* **Abduction:** Moving a limb away from the center line of the body. For example, stepping outward or raising an arm laterally to balance.
* **Bearing:** Supporting a load or body weight against gravity.
* **Load:** The external physical weight or force applied to a structure or joint. In this project, it represents the follower body weight forces that the helper supports.
* **Torque:** The rotational twisting force around a joint axis. This represents the actual muscle effort required to bend a knee or stabilize a hip under a load.
* **Push:** A force directed away from the body. In this interaction, this represents the helper accelerating the follower forward.
* **Pull:** A force directed toward the body. In this interaction, this represents the helper decelerating the follower backward.

**Hand Forces (Arm Data)**
* **ProximoDistal Force (Vertical Lift / Load):** Force traveling along the length of the upper arm. In this walking task, this represents the up / down weight bearing force holding the follower up.
* **DorsoVolar Force (Horizontal Push / Pull):** Force traveling from the back of the hand through the palm. This represents the forward / backward forces exerted on the Follower.
* **Radial Force (Lateral Balance):** Force traveling side to side across the wrist joint. This represents the left /right stabilization preventing the follower from tipping over.

**Ankle Forces (Leg Data)**
* **ProximoDistal Force:** The vertical force traveling up the leg from the ground.
* **AnteroPosterior Force:** The forward and backward accelerating and decelerating forces during a footstep.
* **MedioLateral Force:** The side to side rotational balancing forces on the ankle.

## Folders

* `/`: The MATLAB scripts.
* `/data_csv/`: The extracted force and moment data files. (.csv)
* `/figures/`: The generated interaction plots. (.png)
* `/reports/`: The text summaries. (.txt)

## Setup

Place the AnyBody inverse dynamics simulation files in the root directory to run the analysis. Change the file name definitions in the script declaration sections if the file name is different. For this project we have the files name as follows:

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
* Run `plot_GRFvsHOG.m` to compare the GRF prediction of leg forces and HandOfGod forces.

## Key Findings Summary

**1. Validity of Interaction Forces**
The helper arm sustained extreme loads of 145N vertically and 350N laterally. Sustaining this over an entire walking cycle is highly improbable. This suggests that the motion capture markers from the two subjects were possibly mixed up during recording.

**2. Ground Reaction Force Accuracy**
The predicted GRF tightly aligns with the internal ankle loading. This gap between external impact and internal loading proves the simulation physics engine is calculating correctly.

**3. Assisted vs Single Person Walk**
The single person baseline correctly showed near zero arm forces, whereas the assisted model showed massive spikes. This indicates the simulation correctly captures the interaction force trends, even though the final magnitudes are exaggerated.

**4. Hand Weight Loading**
The right wrist absorbed a 145N (~15kg) peak vertical load. This shows that a substantial body weight was shifted away from the legs and supported by the helper. However, the magnitude is questionable.

**5. Asymmetric Knee Loading**
Because the right arm provided extra support, the right knee only handled a 600N peak vertical load. The unassisted left knee absorbed over 1600N. This assymetry shows that helper took the vertical weight off the assisted leg.

**6. Knee Torque Reduction**
By shifting weight to the hand, the effort required to walk decreased massively. The right knee only needed 8Nm of peak torque, compared to 23Nm for the independent left knee.

**7. Lateral Shift Mechanism**
Relying on asymmetrical one sided support redirects massive forces horizontally. The model had to absorb -800N peak lateral force on the right ankle to avoid tipping over.

**8. Hand Of God vs GRF Hypothesis**
We tested if the Hand Of God was compensating for failed GRF predictions in AnyBody. Statistical analysis showed an R squared of 0.03 and a cosine similarity of 0.58. This low correlation shows that there isn't evidence for the compensating hypothesis.