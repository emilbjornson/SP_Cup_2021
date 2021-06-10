# IEEE Signal Processing Cup 2021
**Configuring an Intelligent Reflecting Surface for Wireless Communications**

The IEEE Signal Processing Society is proud to announce the eighth edition of the Signal Processing Cup: an exciting challenge to control a wireless propagation environment using an intelligent reflecting surface. 

An intelligent reflecting surface is a two-dimensional array of metamaterial whose interaction with electromagnetic waves can be controlled, e.g., by tuning the impedance variations over the surface. These surfaces might be used in the sixth generation (6G) mobile technology to direct wireless signals from a transmitter towards a receiver, to raise the communication performance. The goal of the challenge is to characterize the behavior of an intelligent reflecting surface based on received signals from an over-the-air signaling phase and develop a control algorithm to configure the surface to aid wireless communications.

<center><img src="https://signalprocessingsociety.org/sites/default/files/uploads/images/community_involvement/SPCup2021.jpg"></center>

See the video introduction about the competition: https://youtu.be/Uy7lHEm-Ou0

See the summary video about the competition: https://youtu.be/vsCJqzKvtF8


## Winners

Winning team: T – Cubed, University of Moratuwa, Sri Lanka

First runner-up: Team AGH, AGH University of Science and Technology, Poland

Second runner-up: UnBounded, University of Brasilia, Brazil

You can find descriptions of their solutions on YouTube: https://youtube.com/playlist?list=PLTv48TzNRhaIs9JZ1RqxTVdBjCMUYGdki


## Detailed description of the competition

A detailed description of the IEEE Signal Processing Cup 2021 is found in the document [description.pdf](https://github.com/emilbjornson/SP_Cup_2021/blob/main/description.pdf) in this repository.

Here is brief information about the competition aspects:

**Team composition:** The purpose of this competition is that teams of 3-10 undergraduate students (enrolled as Bachelor or Master students) compete and develop a solution, under the supervision of a faculty member (or someone else with a PhD degree) and (optionally) the tutorship of a PhD student or postdoc. It is the undergraduate students that are responsible for presenting their work on ICASSP 2021, if the team makes it to the final competition (see below). Detailed eligibility criteria are provided in the document [description.pdf](https://github.com/emilbjornson/SP_Cup_2021/blob/main/description.pdf)

**Dataset:** A novel dataset with transmitted and received signals, for different configurations, is provided for the challenge.

**Prize:** The three teams with highest performance in the open competition will be selected as finalists and will be invited to participate in the final competition at ICASSP 2021. The champion team will receive a grand prize of $5,000. The first and the second runner-up will receive a prize of $2,500 and $1,500, respectively.

**Sponsorship:** We gratefully acknowledge [MathWorks, Inc.](https://www.mathworks.com/academia/student-competitions/sp-cup.html) for their continued support of the IEEE Signal Processing Cup. Participating students are encouraged to download the complimentary [Mathworks Student Competitions Software](https://www.mathworks.com/academia/student-competitions/software-request-registration-sp-cup.html) for use in the competition.

<center><img src="https://d32ogoqmya1dw8.cloudfront.net/images/matlab_computation2016/mathworks_logo.png"></center>

## Download datasets

Dataset 1 (123 MB): [https://kth.box.com/v/spcup2021-dataset1](https://kth.box.com/v/spcup2021-dataset1)

Dataset 2 (1.5 GB): [https://kth.box.com/v/spcup2021-dataset2](https://kth.box.com/v/spcup2021-dataset2)

When these links become outdated, the datasets can still be generated using generateDatasets.m in the folder Code_solutions


## Ask questions and interact with other teams:

We use Piazza as Q/A platform: https://piazza.com/ieee_sps/spring2021/spcup2021/home


## Sample solution

Details about the dataset that were not disclosed during the competition, as well as the organizer's sample solution, are found in the paper "[Optimizing a Binary Intelligent Reflecting Surface for OFDM Communications under Mutual Coupling](https://arxiv.org/pdf/2106.04280.pdf)", arXiv:2106.04280

The related code is provided in the folder Code_solutions, where:

generateDatasets.m: Used generate the dataset
testrate.m: Used to evaluate the rates and metric for a given set of configurations
trueParameters.mat: Contains the true channel, needed to evaluate the rates
plotFigureX.m: Used to create Figure X from the the paper mentioned above

The remaining functions are called by the files mentioned above


## Learn more about intelligent reflecting surfaces

A tutorial article that brings you up to speed on the modeling and properties of this technology is:

Emil Björnson, Henk Wymeersch, Bho Matthiesen, Petar Popovski, Luca Sanguinetti, Elisabeth de Carvalho, "[Reconfigurable Intelligent Surfaces: A Signal Processing Perspective With Wireless Applications](https://arxiv.org/pdf/2102.00742)", arXiv:2102.00742.


# Outdated information


## Important dates

Release of the dataset and detailed instructions: February 1, 2021

Registration of team (see below): March 1, 2021

Submission deadline: May 9, 2021

Finalists announced: May 12, 2021

Final at ICASSP (virtual conference): June 6, 2021


## Team registration

Each team must register by March 1 in the following IEEE system:

https://www2.securecms.com/SPCup/SPCRegistration.asp

At least one member per team should also sign up to the Q/A platform Piazza (see below) to get announcements about events, changes in the instructions, and summarizes of Q/A.
