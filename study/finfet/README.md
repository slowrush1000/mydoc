# 20250406


## finfet simulation method

[is-this-ngspice-simulation-correct-with-asap7-transistor-models]
(https://electronics.stackexchange.com/questions/678378/is-this-ngspice-simulation-correct-with-asap7-transistor-models)



> I am trying to run some 7 nm simulations with NGSPICE, and I would like to know if my results are believable or not. I am using the ASAP7 transistor model, which I have converted from HSPICE to NGSPICE. I am not interested in completely precise results - as NGSPICE cannot do noise anyways, but it would be good to know if the results are in the ballpark of the HSPICE results or not.
> 
> I used the following file (TT - typical/typical, slvt - because that is the standard VT):
> 
> https://github.com/The-OpenROAD-Project/asap7/blob/master/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm
> 
> I used NGSPICE-41, which seems to already include the compiled OSDI modules, so I did not need to download and use the OpenVAF compiler to get BSIMCMG_va.osdi unlike what the documentation says.
> 
> https://gigenet.dl.sourceforge.net/project/ngspice/ng-spice-rework/41/ngspice-41_64.7z
> 
> Also in spinit the below line was already commented out:
> 
> * unset osdi_enabled
> 
> When converting the slvt pmos and nmos models from that file, what needed is to specify TYPE=0/1 in NGSPICE, otherwise it does not work.
> 
> This is all what is needed to added BTW:
> 
> .model BSIMCMG_osdi_P BSIMCMG_va (
> + TYPE = 0
> After conversion, running the simulation results in the following warnings:
> 
>   .model bsimcmg_osdi_n bsimcmg_va ( type=1 version=107 bulkmod=1 igcmod=1 ...
> unrecognized parameter (version) - ignored
> unrecognized parameter (coremod) - ignored
> unrecognized parameter (capmod) - ignored
> unrecognized parameter (nseg) - ignored
> unrecognized parameter (etaqm) - ignored
> I compared the values from 7nm_TT_160803.pm to the following file from ngspice-41_64.7z: ngspice-41_64\Spice64\examples\osdi\bsimcmg\Modelcards\modelcard.pmos
> 
> version is completely understandable, as the models were made by different companies.
> coremod/capmod is understandable, they are missing from modelcard.pmos, and they are set to 0 anyways.
> nseg/etaqm can be found in both files with the same values, so why it has not been deleted from modelcard.pmos is a mistery, but whatever.
> However, there are a lot of small and some big differences which I do not understand, and they might make the simulations completely different relative to HSPICE:
> 
> small differences which might be because the node differences (ASAP7 right):
> at=0.0008234 / at=0.001
> cgdo=1e-10 / cgdo=1.6e-10
> cgso=1e-10 / cgso=1.6e-10
> dsub=0.5 / dsub=0.24
> dvt0=0.05006 / dvt0=0.05
> dvt1=0.4 / dvt1=0.36
> eot=2.1e-9 / eot=1e-9
> eta0=0.03952 / eta0=0.094
> hfin=3e-8 / hfin=3.2e-8
> igt=3.5 / igt=2.5
> phig=4.678 / phig=4.9278
> ptwg=6.322 / ptwg=25
> ptwgt=0.0015 / ptwgt=0.004
> rdsw=190.6 / rdsw=200
> tgidl=-0.01 / tgidl=-0.007
> u0=0.02935 / u0=0.0237
> ua1=0.00134 / ua1=0.001032
> vsat=48390 / vsat=60000
> small differences where ASAP7 uses 0, I guess they decided not to simulate these.
> cfd=0.2e-10 / cfd=0
> cfs=0.2e-10 / cfs=0
> deltawcv=-1e-8 / deltawcv=0
> dlc=-9.2e-9 / dlc=0
> kt1=0.08387 / kt1=0
> prt=0.002477 / prt=0
> utl=0.001 / utl=0
> small differences where NGSPICE uses 0, maybe the OSDI module does not support them.
> ucste=0 / ucste=-0.004775
> ute=0 / ute=-1.2
> xl=0 / xl=1e-9
> So far so good, while I have no idea what these parameters above are, the differences do not seem that huge. But then what about the ones below?
> 
> The difference is huge. Is it a problem?
> deltavsat=11.56 / deltavsat=0.17
> geomod=0 / geomod=1
> Only the OSDI in ASAP7 seems to need them, is it a problem?
> - / fpitch=2.7e-8
> - / l=2.1e-8
> - / tfin=6.5e-9
> - / toxg=1.8e-9
> Only the OSDI in NGSPICE seems to need them, is it a problem?
> pclmcv=0.013 / -
> Since I have know nothing about these parameters, any information would be good. Or if somebody would run the simulations in HSPICE would be fine as well.
> 
> "test1.sp" is a simulation of an inverter train. I ignore the first and last inverters, as the first is driven by a clock with arbitrary slew, and the last does not drive anything. At the 0.35 V half point, the delay is between 2-3 ps, which looks reasonable.
> 
> .include 'asap7_TT_slvt.sp'
> 
> .global vdd! gnd!
> 
> .SUBCKT inv in out
>    Npmos  vdd! in out vdd! BSIMCMG_osdi_P
>    Nnmos  gnd! in out gnd! BSIMCMG_osdi_N
> .ENDS
> 
> Vvdd vdd! 0 dc=0.7
> Vgnd gnd! 0 dc=0
> Vin inv_in 0 pulse (0 0.7 20p 10p 10p 20p 500p)
> 
> Xinv1 inv_in inv_x1 inv
> Xinv2 inv_x1 inv_out inv
> Xinv3 inv_out inv_ignore inv
> 
> .tran 0.1p 100p
> 
> .control
>     run
>     set xbrushwidth=3
>     plot inv_in inv_x1 inv_out
> .endc
> 
> .end
> "test2.sp" is the same simulations where every inverter drives for other inverters, but the output of 3 of the 4 are ignored. This creates slower transitions as expected. At the 0.35 V half point, the delay is between 6-7 ps, which looks reasonable but I am not a chip designer so who knows?
> 
> .include 'asap7_TT_slvt.sp'
> 
> .global vdd! gnd!
> 
> .SUBCKT inv in out
>    Npmos  vdd! in out vdd! BSIMCMG_osdi_P
>    Nnmos  gnd! in out gnd! BSIMCMG_osdi_N
>    Npmos2  vdd! in out2 vdd! BSIMCMG_osdi_P
>    Nnmos2  gnd! in out2 gnd! BSIMCMG_osdi_N
>    Npmos3  vdd! in out3 vdd! BSIMCMG_osdi_P
>    Nnmos3  gnd! in out3 gnd! BSIMCMG_osdi_N
>    Npmos4  vdd! in out4 vdd! BSIMCMG_osdi_P
>    Nnmos4  gnd! in out4 gnd! BSIMCMG_osdi_N
> .ENDS
> 
> Vvdd vdd! 0 dc=0.7
> Vgnd gnd! 0 dc=0
> Vin inv_in 0 pulse (0 0.7 20p 10p 10p 20p 500p)
> 
> Xinv1 inv_in inv_x1 inv
> Xinv2 inv_x1 inv_out inv
> Xinv3 inv_out inv_ignore inv
> 
> .tran 0.1p 100p
> 
> .control
>     run
>     set xbrushwidth=3
>     plot inv_in inv_x1 inv_out
> .endc
> 
> .end
> They both include the common file asap7_TT_slvt.sp:
> 
> **** copied from asap7\asap7PDK_r1p7\models\hspice\7nm_TT_160803.pm
> 
> ** Hspice modelcard
> .model BSIMCMG_osdi_P BSIMCMG_va (
> + TYPE = 0
> * .model pmos_slvt pmos level = 72 
> ************************************************************
> *                         general                          *
> ************************************************************
> +version = 107             bulkmod = 1               igcmod  = 1               igbmod  = 0             
> +gidlmod = 1               iimod   = 0               geomod  = 1               rdsmod  = 0             
> +rgatemod= 0               rgeomod = 0               shmod   = 0               nqsmod  = 0             
> +coremod = 0               cgeomod = 0               capmod  = 0               tnom    = 25            
> +eot     = 1e-009          eotbox  = 1.4e-007        eotacc  = 3e-010          tfin    = 6.5e-009      
> +toxp    = 2.1e-009        nbody   = 1e+022          phig    = 4.9278          epsrox  = 3.9           
> +epsrsub = 11.9            easub   = 4.05            ni0sub  = 1.1e+016        bg0sub  = 1.17          
> +nc0sub  = 2.86e+025       nsd     = 2e+026          ngate   = 0               nseg    = 5             
> +l       = 2.1e-008        xl      = 1e-009          lint    = -2.5e-009       dlc     = 0             
> +dlbin   = 0               hfin    = 3.2e-008        deltaw  = 0               deltawcv= 0             
> +sdterm  = 0               epsrsp  = 3.9           
> +toxg    = 1.8e-009
> ************************************************************
> *                            dc                            *
> ************************************************************
> +cit     = 0               cdsc    = 0.003469        cdscd   = 0.001486        dvt0    = 0.05          
> +dvt1    = 0.36            phin    = 0.05            eta0    = 0.094           dsub    = 0.24          
> +k1rsce  = 0               lpe0    = 0               dvtshift= 0               qmfactor= 0             
> +etaqm   = 0.54            qm0     = 2.183e-012      pqm     = 0.66            u0      = 0.0237        
> +etamob  = 4               up      = 0               ua      = 1.133           eu      = 0.05          
> +ud      = 0.0105          ucs     = 0.2672          rdswmin = 0               rdsw    = 200           
> +wr      = 1               rswmin  = 0               rdwmin  = 0               rshs    = 0             
> +rshd    = 0               vsat    = 60000           deltavsat= 0.17            ksativ  = 1.592         
> +mexp    = 2.491           ptwg    = 25              pclm    = 0.01            pclmg   = 1             
> +pdibl1  = 800             pdibl2  = 0.005704        drout   = 4.97            pvag    = 200           
> +fpitch  = 2.7e-008        rth0    = 0.15            cth0    = 1.243e-006      wth0    = 2.6e-007      
> +lcdscd  = 0               lcdscdr = 0               lrdsw   = 1.3             lvsat   = 1441          
> ************************************************************
> *                         leakage                          *
> ************************************************************
> +aigc    = 0.007           bigc    = 0.0015          cigc    = 1               dlcigs  = 5e-009        
> +dlcigd  = 5e-009          aigs    = 0.006           aigd    = 0.006           bigs    = 0.001944      
> +bigd    = 0.001944        cigs    = 1               cigd    = 1               poxedge = 1.152         
> +agidl   = 2e-012          agisl   = 2e-012          bgidl   = 1.5e+008        bgisl   = 1.5e+008      
> +egidl   = 1.142           egisl   = 1.142         
> ************************************************************
> *                            rf                            *
> ************************************************************
> ************************************************************
> *                         junction                         *
> ************************************************************
> ************************************************************
> *                       capacitance                        *
> ************************************************************
> +cfs     = 0               cfd     = 0               cgso    = 1.6e-010        cgdo    = 1.6e-010      
> +cgsl    = 0               cgdl    = 0               ckappas = 0.6             ckappad = 0.6           
> +cgbo    = 0               cgbl    = 0             
> ************************************************************
> *                       temperature                        *
> ************************************************************
> +tbgasub = 0.000473        tbgbsub = 636             kt1     = 0               kt1l    = 0             
> +ute     = -1.2            utl     = 0               ua1     = 0.001032        ud1     = 0             
> +ucste   = -0.004775       at      = 0.001           ptwgt   = 0.004           tmexp   = 0             
> +prt     = 0               tgidl   = -0.007          igt     = 2.5           
> ************************************************************
> *                          noise                           *
> ************************************************************
> **)
> 
> ** Hspice modelcard
> .model BSIMCMG_osdi_N BSIMCMG_va (
> + TYPE = 1
> * .model nmos_slvt nmos level = 72 
> ************************************************************
> *                         general                          *
> ************************************************************
> +version = 107             bulkmod = 1               igcmod  = 1               igbmod  = 0             
> +gidlmod = 1               iimod   = 0               geomod  = 1               rdsmod  = 0             
> +rgatemod= 0               rgeomod = 0               shmod   = 0               nqsmod  = 0             
> +coremod = 0               cgeomod = 0               capmod  = 0               tnom    = 25            
> +eot     = 1e-009          eotbox  = 1.4e-007        eotacc  = 1e-010          tfin    = 6.5e-009      
> +toxp    = 2.1e-009        nbody   = 1e+022          phig    = 4.2466          epsrox  = 3.9           
> +epsrsub = 11.9            easub   = 4.05            ni0sub  = 1.1e+016        bg0sub  = 1.17          
> +nc0sub  = 2.86e+025       nsd     = 2e+026          ngate   = 0               nseg    = 5             
> +l       = 2.1e-008        xl      = 1e-009          lint    = -2e-009         dlc     = 0             
> +dlbin   = 0               hfin    = 3.2e-008        deltaw  = 0               deltawcv= 0             
> +sdterm  = 0               epsrsp  = 3.9           
> +toxg    = 1.80e-009
> ************************************************************
> *                            dc                            *
> ************************************************************
> +cit     = 0               cdsc    = 0.01            cdscd   = 0.01            dvt0    = 0.05          
> +dvt1    = 0.47            phin    = 0.05            eta0    = 0.07            dsub    = 0.35          
> +k1rsce  = 0               lpe0    = 0               dvtshift= 0               qmfactor= 2.5           
> +etaqm   = 0.54            qm0     = 0.001           pqm     = 0.66            u0      = 0.0303        
> +etamob  = 2               up      = 0               ua      = 0.55            eu      = 1.2           
> +ud      = 0               ucs     = 1               rdswmin = 0               rdsw    = 200           
> +wr      = 1               rswmin  = 0               rdwmin  = 0               rshs    = 0             
> +rshd    = 0               vsat    = 70000           deltavsat= 0.2             ksativ  = 2             
> +mexp    = 4               ptwg    = 30              pclm    = 0.05            pclmg   = 0             
> +pdibl1  = 0               pdibl2  = 0.002           drout   = 1               pvag    = 0             
> +fpitch  = 2.7e-008        rth0    = 0.225           cth0    = 1.243e-006      wth0    = 2.6e-007      
> +lcdscd  = 5e-005          lcdscdr = 5e-005          lrdsw   = 0.2             lvsat   = 0             
> ************************************************************
> *                         leakage                          *
> ************************************************************
> +aigc    = 0.014           bigc    = 0.005           cigc    = 0.25            dlcigs  = 1e-009        
> +dlcigd  = 1e-009          aigs    = 0.0115          aigd    = 0.0115          bigs    = 0.00332       
> +bigd    = 0.00332         cigs    = 0.35            cigd    = 0.35            poxedge = 1.1           
> +agidl   = 1e-012          agisl   = 1e-012          bgidl   = 10000000        bgisl   = 10000000      
> +egidl   = 0.35            egisl   = 0.35          
> ************************************************************
> *                            rf                            *
> ************************************************************
> ************************************************************
> *                         junction                         *
> ************************************************************
> ************************************************************
> *                       capacitance                        *
> ************************************************************
> +cfs     = 0               cfd     = 0               cgso    = 1.6e-010        cgdo    = 1.6e-010      
> +cgsl    = 0               cgdl    = 0               ckappas = 0.6             ckappad = 0.6           
> +cgbo    = 0               cgbl    = 0             
> ************************************************************
> *                       temperature                        *
> ************************************************************
> +tbgasub = 0.000473        tbgbsub = 636             kt1     = 0               kt1l    = 0             
> +ute     = -0.7            utl     = 0               ua1     = 0.001032        ud1     = 0             
> +ucste   = -0.004775       at      = 0.001           ptwgt   = 0.004           tmexp   = 0             
> +prt     = 0               tgidl   = -0.007          igt     = 2.5           
> ************************************************************
> *                          noise                           *
> ************************************************************
> **)
> Result of simulation - left 4 inv, right 1 inv
> 
> "from 7nm_TT_160803 pm.txt" and "from modelcard pmos.txt" are the parameters from the two different sources, sorted and converted to similar diffable formats. I have uploaded all the files here:
> 
> https://drive.google.com/file/d/11-vKHFhfnxR9_VJzYrE4iICk3xOMcqq7/view?usp=sharing
> 
> Does this simulation result in reasonable output? Or did I screw up something?

> Ok, if anybody wants to do this, here is the 'solution'.
> 
> First, do not use NGSPICE if possible, because
> 
> It crashes when using its graphing UI in case there are too many signals displayed.
> 
> They do not seem to have a use case for including the BSIMCMG models. The transistor parameters are completely bogus - those are test parameters for the BSIMCMG model itself. But at least they modify the model to converge better, which is a plus - still useless though in my opinion.
> 
> Instead use Xyce (https://xyce.sandia.gov/), which is free but requires registration because of export restrictions or something. It includes the BSIMCMG model variant level 110, there are not many changes after that for finfets.
> 
> The transistor specification file (https://github.com/The-OpenROAD-Project/asap7/blob/master/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm) has to be slightly modified:
> 
> Change 'level' from 72 to 110.
> 
> Remove 'version', 'coremod' and 'capmod'.
> 
> I saved it as 'asap7_TT.sp', you have to do the same changes for SS and FF corners if needed.
> 
> ** ASAP TT models v1.0 8/3/16
> 
> ** Hspice modelcard
> .model nmos_lvt nmos level = 110 
> ************************************************************
> *                         general                          *
> ************************************************************
> +                          bulkmod = 1               igcmod  = 1               igbmod  = 0             
> +gidlmod = 1               iimod   = 0               geomod  = 1               rdsmod  = 0             
> +rgatemod= 0               rgeomod = 0               shmod   = 0               nqsmod  = 0             
> +                          cgeomod = 0                                         tnom    = 25            
> +eot     = 1e-009          eotbox  = 1.4e-007        eotacc  = 1e-010          tfin    = 6.5e-009      
> +toxp    = 2.1e-009        nbody   = 1e+022          phig    = 4.307           epsrox  = 3.9           
> +epsrsub = 11.9            easub   = 4.05            ni0sub  = 1.1e+016        bg0sub  = 1.17          
> +nc0sub  = 2.86e+025       nsd     = 2e+026          ngate   = 0               nseg    = 5             
> +l       = 2.1e-008        xl      = 1e-009          lint    = -2e-009         dlc     = 0             
> +dlbin   = 0               hfin    = 3.2e-008        deltaw  = 0               deltawcv= 0             
> +sdterm  = 0               epsrsp  = 3.9           
> +toxg    = 1.80e-009
> ...
> The extracted ASAP7 library (https://github.com/The-OpenROAD-Project/asap7/blob/master/asap7sc7p5t_28/CDL/xAct3D_extracted/asap7sc7p5t_28_R.sp) has to be modified as well to be compatible with Xyce. Use the regex below to replace to nothing to delete the incompatible stuff (I used Visual Studio Code, do not remember if case sensitive must be on or off):
> 
> (W|\$\w+)=\d+(\.\d+|)(e[+-]\d+|)|\$layer=\w+
> Here there are 4 versions, SRAM > R > L > SL, which are faster left to right, but also have around 10x higher leakage each step. I guess R might be Regular, and SL does not mean Standard, but instead SuperLow.
> 
> Keep in mind that there are differences between the SPICE dialects used by NGSPICE and Xyce:
> 
> NGSPICE uses N for BSIMCMG transistors, while Xyce uses M. This is hard to spot...
> 
> I might remember wrong but there seems to be some differences between lines starting with spaces, so do not indent your netlist. (I might remember wrong though, it was a long time ago...)
> 
> Xyce supports only a single .tran line, and you can loop parameters by .step or similar - read the documentation.
> 
> In Xyce you should use 0 as gnd. Defining a different gnd would slow down simulations. Vdd handling is slightly different as well.
> 
> Parameter handling is much better in Xyce, you declare a parameter with .param, and then can use the same name in a .step or similar. Multiple .step directives run all combinations, the current params used for the running simulation can be read from the .res file, which is appended realtime.
> 
> You can do something like this (Note that FAxp33_ASAP7_6t_SL has a different order of nets, look out for this. Here we use asap7sc7p5t_28_R, but you might want define .subckt for all library blocks):
> 
> .param vcc=0.9
> *.step vcc LIST 0.6 0.7 0.8 0.9
> .tran 1p 400p
> .global vdd!
> Vvdd vdd! 0 dc {vcc}
> ...
> .include 'asap7_TT.sp'
> *.include 'asap7sc6t_26_SL_211010.sp'
> *.include 'asap7sc7p5t_28_SL.sp'
> *.include 'asap7sc7p5t_28_L.sp'
> .include 'asap7sc7p5t_28_R.sp'
> .subckt fa7 a b cin ncout nsout
> *Xadd a 0 vdd! b cin ncout nsout FAxp33_ASAP7_6t_SL
> *Xadd 0 vdd! a b cin ncout nsout FAx1_ASAP7_75t_SL
> *Xadd 0 vdd! a b cin ncout nsout FAx1_ASAP7_75t_L
> Xadd 0 vdd! a b cin ncout nsout FAx1_ASAP7_75t_R
> .ends
> ...
> Xadd1 a1 b1 cin0 ncout1 nsout1 fa7
> ...
> .end
> Now the problem with this approach what you will see, is that with the extracted parasitics the library blocks (like Full Adder) are 2-3x slower than when you only wire ideal transistors together with perfect zero length wires. While it is fine modeling those circuits, the wires connecting blocks are not extracted, and it does matter in this case. On the other hand, if you have software to extract those wires then you do not need this kind of simulation I guess...
> 
> ps: forgot to add plotting differences
> 
> You can plot with the below line:
> 
> .print tran FORMAT=GNUPLOT 
> +V(a1in) 
> +V(a0) V(b0) V(xfirst_stage_y:a0_n) V(xfirst_stage_y:b0_n) 
> ...
> Then in gnuplot draw the plot like this:
> 
> set autoscale xy
> set key autotitle columnheader
> set grid
> set xtics 10
> set ytics 400
> plot for [i=3:39] 'filename.sp.prn' using ($2*1e12):((column(i)-i)*400) with lines lw 1.5
> The loop (plot for) in the last line will use y coordinates from column(i), while x coordinates will come from column(2), which is the $2: part. *1e12 will display picoseconds. (column(i)-i)*400 will plot different columns below each other - this expects 0..0.9 V values, otherwise the subgraphs will collide. lw 1.5 is the line weight, otherwise it is hard to see.

# ngspice finfet 지원

## gemini 문의

> finfet을 지원하는 ngspice를 알려주세요
> 
> 네, ngspice는 FinFET 모델을 지원합니다.
> 
> ngspice에서 FinFET 모델을 사용하는 방법:
> 
> ngspice는 OSDI (Open Simulation Data Interface) 와 OpenVAF (Open Verilog-A Framework) 인터페이스를 통해 Verilog-A로 작성된 최신 소자 모델들을 통합할 수 있습니다. FinFET 모델은 일반적으로 Verilog-A로 제공되므로, 이 인터페이스들을 활용하여 ngspice에서 FinFET 시뮬레이션을 수행할 수 있습니다.
> 
> 구체적인 방법:
> 
> FinFET 모델 파일 확보: FinFET 공정 Foundry (예: TSMC, Samsung, GlobalFoundries 등) 또는 모델 개발 기관에서 제공하는 FinFET SPICE 모델 (Verilog-A 형식)을 구해야 합니다. 공개된 연구용 FinFET 모델도 있을 수 있습니다.
> ngspice 설정:
> 최신 버전의 ngspice (39 버전 이상 권장)를 사용해야 OSDI/OpenVAF 인터페이스를 제대로 활용할 수 있습니다.
> ngspice가 Verilog-A 컴파일러 (예: vpp)와 OSDI 라이브러리를 인식할 수 있도록 환경 변수가 설정되어 있는지 확인합니다.
> Netlist 작성:
> Netlist 파일에서 FinFET 모델을 호출하고, 필요한 파라미터들을 설정합니다. 이는 일반적인 SPICE 모델 사용법과 유사합니다.
> .MODEL 구문 대신 .subckt 정의를 사용하여 Verilog-A 모델을 포함할 수 있습니다.
> 모델 파일의 경로를 지정해야 할 수도 있습니다.
> 시뮬레이션 실행: 작성된 Netlist 파일을 사용하여 ngspice를 실행합니다.
> 주의사항:
> 
> FinFET 모델은 일반적인 MOSFET 모델보다 훨씬 복잡하며, 많은 파라미터를 가집니다. 모델 사용 설명서와 파라미터 정의를 정확히 이해해야 합니다.
> FinFET 모델 파일은 Foundry의 기밀 자산인 경우가 많으므로, 함부로 공유하거나 사용하는 것에 주의해야 합니다.
> 공개된 FinFET 모델은 특정 공정이나 기술 노드를 대상으로 개발되었을 수 있으므로, 사용하려는 환경과 맞는지 확인해야 합니다.
> Verilog-A 모델의 컴파일 및 ngspice 연동 과정은 다소 복잡할 수 있으며, 관련 지식이 필요할 수 있습니다.
> 참고 자료:
> 
> ngspice User's Manual: OSDI/OpenVAF 관련 섹션을 참고하십시오.
> ngspice 웹사이트 및 포럼: FinFET 모델 사용 관련 논의나 튜토리얼을 찾아볼 수 있습니다. (https://sourceforge.net/p/ngspice/discussion/127605/thread/07d5bd0dfc/)
> OSDI/OpenVAF 관련 자료: Verilog-A 모델을 ngspice에 통합하는 방법에 대한 정보를 얻을 수 있습니다.
> 결론적으로, ngspice는 OSDI/OpenVAF 인터페이스를 통해 FinFET 모델을 지원하며, Verilog-A 형식의 FinFET 모델과 최신 버전의 ngspice를 사용하여 FinFET 회로 시뮬레이션을 수행할 수 있습니다. 하지만 실제 FinFET 모델 파일 확보 및 사용은 모델 제공처의 정책과 사용자의 관련 지식에 따라 달라질 수 있습니다.
> 
> _(https://gemini.google.com/app/f03f1afa295fd6fb?hl=ko)_

## ASAP: Arizona State Preditive PDK
    https://asap.asu.edu/
    https://github.com/The-OpenROAD-Project/asap7
    https://github.com/The-OpenROAD-Project/asap7_pdk_r1p7/tree/58d72c9d291e186a77468586ab0c43d8a21eda6a

## FreePDK15
    https://eda.ncsu.edu/freepdk15/
    https://github.com/ncsu-eda/FreePDK3

## gemini 문의

> finfet inverter chain spice simulation이 가능한 공개된 예제를 알려주세요
> 
> 
> FinFET 인버터 체인 SPICE 시뮬레이션이 가능한 공개된 예제를 찾으시는군요. 아쉽게도 특정 기술 노드(예: 7nm, 14nm)의 FinFET 모델 파라미터까지 포함된 완전한 인버터 체인 SPICE 예제를 바로 다운로드하여 사용할 수 있는 형태로 공개된 경우는 드뭅니다.
> 
> 그 이유는 다음과 같습니다.
> 
> 모델 파라미터의 저작권 및 기밀 유지: FinFET 모델 파라미터는 반도체 제조사(파운드리)의 핵심 기술 정보에 해당하며, 일반적으로 기밀로 유지됩니다. 따라서 공개적으로 배포되지 않습니다.
> 기술 노드의 다양성: FinFET 기술은 계속 발전하고 있으며, 각 기술 노드마다 모델 파라미터가 다릅니다. 특정 기술 노드에 대한 일반적인 예제를 제공하기 어렵습니다.
> 시뮬레이터 종속성: 일부 예제는 특정 SPICE 시뮬레이터(예: HSPICE, Cadence Spectre)에 최적화되어 있을 수 있습니다.
> 하지만 다음과 같은 방법으로 FinFET 인버터 체인 SPICE 시뮬레이션을 위한 정보를 얻고 직접 구성해 볼 수 있습니다.
> 
> 1. 공개된 FinFET 모델 및 튜토리얼 활용:
> 
> PTM (Predictive Technology Model): ASU (Arizona State University)에서 제공하는 PTM 모델은 연구 및 교육 목적으로 널리 사용됩니다. FinFET 모델도 포함되어 있으며, 웹사이트에서 관련 파일을 다운로드할 수 있습니다.
> https://ptm.asu.edu/latest.html
> 이 모델은 상업용 파운드리 공정과는 차이가 있을 수 있지만, FinFET의 기본적인 동작 원리를 이해하고 시뮬레이션을 수행하는 데 유용합니다.
> FreePDK: 일부 오픈 소스 PDK (Process Design Kit) 프로젝트에서 기본적인 FinFET 모델을 제공하기도 합니다. 예를 들어 FreePDK15는 15nm FinFET 모델을 포함하고 있습니다.
> https://arxiv.org/pdf/2009.04600
> 대학 강의 자료 및 논문: 일부 대학 강의 자료나 학술 논문에서 FinFET 인버터 시뮬레이션 예제 코드의 일부 또는 개념을 제시하는 경우가 있습니다. Google Scholar 등의 검색 엔진을 활용하여 찾아볼 수 있습니다.
> 2. SPICE 시뮬레이터 예제 및 튜토리얼 참고:
> 
> ngspice: 오픈 소스 SPICE 시뮬레이터인 ngspice의 튜토리얼이나 예제에는 기본적인 MOSFET 인버터 시뮬레이션 예제가 포함되어 있을 수 있습니다. 이를 FinFET 모델로 변경하여 적용해 볼 수 있습니다.
> https://cornell-ece5745.github.io/ece5745-tut10-spice/ (CMOS 예제이지만 FinFET 모델 적용 가능)
> LTSpice: 무료 SPICE 시뮬레이터인 LTSpice의 예제에서도 MOSFET 인버터 회로를 찾아보고, FinFET 모델을 적용하는 방법을 학습할 수 있습니다.
> 3. 직접 SPICE Netlist 작성:
> 
> 앞서 제공해 드린 기본적인 FinFET 인버터 체인 SPICE Netlist 예제를 기반으로, 구한 FinFET 모델 파일을 포함하고 모델 파라미터를 조정하여 시뮬레이션을 수행해 볼 수 있습니다.
> 
> 모델 파라미터 예제 (PTM 14nm FinFET 모델 기반, 예시):
> 
> PTM 웹사이트에서 해당 기술 노드의 모델 파일을 다운로드하면 .pm (PMOS) 및 .nm (NMOS) 파일에 상세한 모델 파라미터가 정의되어 있습니다. Netlist에서 .model 구문을 사용하여 이 모델을 참조하게 됩니다.
> 
> 예를 들어, PTM 14nm FinFET NMOS 모델 파일의 일부는 다음과 유사할 수 있습니다.
> 
> .model FinFET_n NMOS (
> + Version=4.0
> + Lmin=1e-8 Lmax=1e-6 Wmin=1e-8 Wmax=1e-6
> + Lint=1.5e-9 Wint=1.5e-9
> + Toxe=1.5e-9
> + Vth0=0.3
> + ... (수많은 모델 파라미터) ...
> )
> Netlist에서는 다음과 같이 소자를 정의할 때 이 모델 이름을 사용합니다.
> 
> 코드 스니펫
> 
> M2 out in 0 0 FinFET_n l=14n nfin=3 ...
> 결론적으로, 완벽하게 готовый (ready-made) 형태의 공개된 FinFET 인버터 체인 SPICE 시뮬레이션 예제를 찾기는 어렵지만, 공개된 FinFET 모델 (예: PTM)과 SPICE 시뮬레이터 튜토리얼을 활용하여 직접 Netlist를 작성하고 시뮬레이션을 수행해 볼 수 있습니다.
> 
> 시작하기 위해서는 다음 단계를 추천합니다.
> 
> PTM 웹사이트에서 원하는 기술 노드의 FinFET 모델 파일을 다운로드합니다.
> 앞서 제공된 기본적인 인버터 체인 SPICE Netlist 예제를 준비합니다.
> Netlist의 .include 문에 다운로드한 모델 파일의 경로를 정확하게 지정합니다.
> Netlist의 NMOS 및 PMOS 소자 정의에서 .model 파라미터를 다운로드한 모델 이름으로 변경합니다.
> 원하는 채널 길이 (l) 및 핀 개수 (nfin) 파라미터를 설정합니다.
> SPICE 시뮬레이터를 사용하여 Netlist를 실행하고 결과를 확인합니다.
> 이 과정을 통해 FinFET 인버터 체인의 기본적인 SPICE 시뮬레이션을 수행하고, 모델 파라미터가 회로 동작에 미치는 영향을 이해하는 데 도움이 될 것입니다.
> 

## gemini 문의

> length와 nfit으로만 구성된 finfet inverter chain spice simulation 예제와 model parameter 예제를 알려주세요
> 
> 
> length와 nfin으로만 구성된 FinFET 인버터 체인 SPICE 시뮬레이션 예제
> 다음은 length(채널 길이)와 nfin(핀 개수)으로만 구성된 간단한 FinFET 인버터 체인 SPICE 시뮬레이션 예제입니다. 이 예제에서는 레벨 54 (BSIM4) 모델을 사용하며, 최소한의 파라미터만을 포함합니다. 실제 시뮬레이션에서는 더 많은 모델 파라미터가 필요할 수 있습니다.
> 
> SPICE Netlist 예제:
> 
> 코드 스니펫
> 
> * FinFET 인버터 체인 예제
> 
> * 라이브러리 포함 (실제 모델 파일 경로로 수정 필요)
> .include 'your_finfet_model.lib'
> 
> * 전원 공급
> Vdd vdd 0 1.0
> 
> * 입력 신호
> Vin in 0 pulse (0 1 0 100p 100p 500p 1n)
> 
> * 첫 번째 인버터
> M1 out1 in vdd vdd pmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
> M2 out1 in 0 0 nmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
> 
> * 두 번째 인버터
> M3 out2 out1 vdd vdd pmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
> M4 out2 out1 0 0 nmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
> 
> * 세 번째 인버터
> M5 out3 out2 vdd vdd pmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
> M6 out3 out2 0 0 nmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
> 
> * 출력 로드 (선택 사항)
> Cload out3 0 1f
> 
> * 시뮬레이션 설정
> .tran 1p 2n
> .options post
> 
> * 출력
> .plot tran v(in) v(out1) v(out2) v(out3)
> .end
> 설명:
> 
> .include 'your_finfet_model.lib': FinFET 모델 파라미터가 정의된 라이브러리 파일을 포함합니다. 실제 사용하는 모델 파일의 경로로 수정해야 합니다.
> Vdd vdd 0 1.0: 1.0V의 전원 공급을 정의합니다.
> Vin in 0 pulse ...: 입력 신호로 0V에서 1V로 상승하는 펄스 파형을 정의합니다.
> M1, M3, M5: PMOS FinFET 소자를 정의합니다.
> pmos: PMOS 소자임을 나타냅니다.
> l=10n: 채널 길이를 10nm로 설정합니다.
> nfin=4: 핀 개수를 4개로 설정합니다.
> nf=2: 핑거(finger) 수를 2개로 설정합니다. (총 채널 폭은 nfin * nf * 핀 폭으로 결정됩니다. 핀 폭은 모델 파라미터에 정의되어 있습니다.)
> ad, as, pd, ps: 드레인/소스 영역의 면적 및 주변 길이를 설정합니다. 이는 기생 커패시턴스에 영향을 미치지만, 기본적인 동작에는 필수적이지 않습니다. 예시 값을 사용했으며, 필요에 따라 조정하거나 모델에 따라 생략할 수도 있습니다.
> M2, M4, M6: NMOS FinFET 소자를 정의합니다. 파라미터는 PMOS와 유사하게 설정합니다.
> Cload out3 0 1f: 출력 노드에 1fF의 부하 커패시터를 연결합니다 (선택 사항).
> .tran 1p 2n: 트랜지언트 시뮬레이션을 1ps 스텝 크기로 2ns 동안 수행합니다.
> .options post: 시뮬레이션 결과를 저장합니다.
> .plot tran v(in) v(out1) v(out2) v(out3): 입력 및 각 인버터의 출력 전압을 플롯합니다.
> 주의사항:
> 
> 위 예제는 매우 기본적인 구조이며, 실제 FinFET 모델은 훨씬 더 많은 파라미터를 가집니다. 정확한 시뮬레이션을 위해서는 사용하는 파운드리 또는 모델 제공업체에서 제공하는 상세 모델 파일을 사용해야 합니다.
> your_finfet_model.lib 파일은 실제 사용하는 FinFET 모델 라이브러리 파일로 변경해야 합니다. 이 파일에는 NMOS 및 PMOS FinFET의 모델 파라미터 (예: 문턱 전압, 이동도, 산화막 커패시턴스 등)가 정의되어 있습니다.
> ad, as, pd, ps 파라미터는 기본적인 동작 시뮬레이션에는 큰 영향을 미치지 않을 수 있지만, 고속 동작이나 정확한 타이밍 분석을 위해서는 적절한 값을 설정해야 합니다.
> nf 파라미터는 핑거 수를 나타내며, 총 채널 폭에 영향을 미칩니다. 이는 드라이브 스트렝스에 영향을 주므로, 필요에 따라 조정할 수 있습니다.
> FinFET 모델 파라미터 예제
> FinFET 모델 파라미터는 사용하는 모델 (예: BSIM-IMG, UFDG, 기타 파운드리 제공 모델) 및 기술 노드에 따라 매우 다양합니다. 일반적으로 모델 파일 (.lib 또는 .mod 확장자) 형태로 제공되며, SPICE netlist에서 .include 문을 사용하여 포함됩니다.
> 
> 다음은 BSIM4 모델에서 length (L) 및 nfin과 관련된 주요 파라미터의 예시입니다. 실제 모델 파일에는 훨씬 많은 파라미터가 정의되어 있습니다.
> 
> NMOS BSIM4 모델 파라미터 예시 (일부):
> 
> .model nmos nmos
> + version = 4.8.0
> + lint = 1e-9
> + nch = 1.7e17
> + vth0 = 0.4
> + u0 = 0.067
> + ua = 2.25e-9
> + ub = 5.87e-19
> + uc = -0.0465
> + vsat = 1.62e5
> + a0 = 1
> + ags = 0.272
> + b0 = 0.6
> + b1 = 0.05
> + keta = -0.047
> + dwg = 5e-9  * 핀 폭 변화량 (게이트 폭)
> + lwg = 5e-9  * 핀 폭 변화량 (채널 길이)
> + nfin = 1    * 기준 핀 개수 (모델 스케일링에 사용될 수 있음)
> + wfin = 7e-9 * 핀 폭
> + hfin = 30e-9 * 핀 높이
> + tfin = 7e-9 * 핀 두께
> + ... (기타 모델 파라미터)
> .ends nmos
> PMOS BSIM4 모델 파라미터 예시 (일부):
> 
> .model pmos pmos
> + version = 4.8.0
> + lint = 1e-9
> + pch = 4e17
> + vth0 = -0.45
> + u0 = 0.027
> + ua = 4.35e-9
> + ub = 1.67e-18
> + uc = -0.0465
> + vsat = 1.12e5
> + a0 = 0.8
> + ags = 0.3
> + b0 = 0.7
> + b1 = 0.06
> + keta = -0.05
> + dwg = 5e-9
> + lwg = 5e-9
> + nfin = 1
> + wfin = 7e-9
> + hfin = 30e-9
> + tfin = 7e-9
> + ... (기타 모델 파라미터)
> .ends pmos
> 설명:
> 
> .model nmos nmos: NMOS 모델을 정의하고 이름을 nmos로 지정합니다.
> version: BSIM 모델 버전을 나타냅니다.
> lint: 유효 채널 길이 보정 값입니다.
> nch, pch: 채널 도핑 농도입니다.
> vth0: 영 바이어스 문턱 전압입니다.
> u0: 저전계 이동도입니다.
> ua, ub, uc: 이동도 감쇠 파라미터입니다.
> vsat: 포화 속도입니다.
> a0, ags, b0, b1, keta: 단채널 효과 파라미터입니다.
> dwg, lwg: 게이트 폭 및 채널 길이 변화에 따른 파라미터 변화량입니다. FinFET 구조에 따라 다르게 정의될 수 있습니다.
> nfin: 기준 핀 개수입니다. 실제 소자의 핀 개수는 netlist에서 지정합니다. 모델은 이 값을 기준으로 스케일링될 수 있습니다.
> wfin: 핀 폭입니다. FinFET의 성능에 중요한 영향을 미칩니다.
> hfin: 핀 높이입니다. 채널 폭과 관련됩니다.
> tfin: 핀 두께입니다.
> ... (기타 모델 파라미터): 이 외에도 다양한 파라미터들이 모델의 전기적 특성을 정의합니다.
> 모델 파일 사용 방법:
> 
> FinFET 모델 파일을 파운드리 또는 모델 제공업체로부터 구합니다.
> SPICE netlist의 최상단에 .include '모델_파일_경로' 와 같이 모델 파일을 포함시킵니다.
> Netlist에서 FinFET 소자를 정의할 때 .model 문에서 해당 모델 이름을 참조합니다 (예: pmos 또는 nmos).
> 소자의 l (length) 및 nfin 파라미터를 원하는 값으로 설정합니다.
> 주의사항:
> 
> 실제 모델 파라미터 값은 기술 노드, 파운드리, 모델 버전에 따라 크게 다릅니다. 위 예시는 일반적인 BSIM4 모델의 일부 파라미터를 보여주는 것이며, 실제 사용 가능한 값과 다를 수 있습니다.
> 정확한 시뮬레이션을 위해서는 사용하는 기술에 맞는 정확한 모델 파일을 사용해야 합니다.
> 일부 모델에서는 nfin 외에 핑거 수 (nf)와 같은 파라미터를 함께 사용하여 소자의 크기를 조절하기도 합니다. 모델 문서를 참고하여 정확한 사용법을 확인해야 합니다.
> 위 예시와 설명을 통해 length와 nfin으로 구성된 FinFET 인버터 체인 SPICE 시뮬레이션을 구성하고, 관련 모델 파라미터를 이해하는 데 도움이 되기를 바랍니다. 실제 시뮬레이션 환경에 맞춰 모델 파일 경로 및 파라미터 값을 적절히 수정하여 사용하시기 바랍니다.

# 20250405
## gemini 문의 

> 삼성 파운드리 PDK (Process Design Kit)에서 FinFET width를 찾는 방법은 여러 단계와 다양한 정보를 포함할 수 있습니다. 일반적으로 직접적인 "FinFET width" 파라미터 이름보다는 관련된 파라미터들을 통해 유추하거나 계산해야 할 가능성이 높습니다.
> 
> 다음은 삼성 파운드리 PDK에서 FinFET width 정보를 찾을 수 있는 방법과 관련된 정보들입니다.
> 
> 1. PDK 문서 (Documentation) 확인:
> 
> 설계 규칙 매뉴얼 (Design Rule Manual, DRM): PDK에 포함된 DRM은 해당 공정 노드의 모든 설계 규칙을 상세하게 설명합니다. FinFET 소자의 물리적 레이아웃 규칙 (예: Fin pitch, Fin width (TSi), Fin height, Gate length 등)을 포함하고 있을 가능성이 높습니다. 이 문서에서 "Fin Width", "TSi" 또는 관련 키워드를 검색해 보세요.
> 모델 파라미터 문서: SPICE 모델 파라미터에 대한 설명 문서도 제공될 수 있습니다. 이 문서에는 시뮬레이션 모델에서 사용되는 파라미터들의 정의와 의미가 설명되어 있습니다. "Wfin" 또는 유효 채널 폭 (Weff)과 관련된 파라미터를 찾아보세요.
> 유저 가이드 (User Guide): PDK 사용 방법, 라이브러리 설명 등을 담은 유저 가이드에도 FinFET 소자의 기본적인 정보가 언급될 수 있습니다.
> 2. 라이브러리 정보 확인:
> 
> 심볼 및 레이아웃 뷰: 제공되는 심볼 및 레이아웃 뷰의 정보를 통해 FinFET 소자의 기본적인 구조를 파악할 수 있습니다. 레이아웃 뷰에서는 Fin의 개수나 기본적인 형태를 확인할 수 있을 수 있습니다.
> 파라미터화된 셀 (PCell) 정보: FinFET 소자가 PCell 형태로 제공되는 경우, 해당 PCell의 파라미터 리스트를 확인하면 Fin width 관련 파라미터를 찾을 수 있습니다. PCell은 사용자가 원하는 width, length, finger 개수 등을 설정하여 소자를 생성할 수 있도록 제공됩니다.
> 3. SPICE 모델 (Simulation Model) 확인:
> 
> 모델 파일: 제공되는 SPICE 모델 파일 (.lib, .scs 등)을 직접 열어 FinFET 모델의 파라미터 리스트를 확인할 수 있습니다. 모델 카드 내에서 "Wfin", "TSi" 또는 유효 채널 폭과 관련된 파라미터를 찾아보세요.
> 유효 채널 폭 (Weff) 계산: SPICE 모델에서는 직접적인 Fin width 파라미터 대신 유효 채널 폭 (Weff) 파라미터가 제공될 수 있습니다. Weff는 Fin width (Wfin), Fin height (Hfin), 그리고 핀의 개수 (Nfin)를 이용하여 계산됩니다. 제공되는 모델 파라미터와 문서를 통해 Weff 계산 방법을 확인해야 합니다. 일반적으로 다음과 같은 관계를 가집니다.
> 더블 게이트: Weff ≈ 2 * Hfin * Nfin
> 트라이 게이트: Weff ≈ (2 * Hfin + Wfin) * Nfin
> PDK 문서에서 Hfin에 대한 정보를 찾거나, Weff와 Nfin 사이의 관계를 통해 Wfin을 유추해야 할 수 있습니다.
> 4. 삼성 파운드리 기술 지원:
> 
> PDK 문서를 찾아봐도 명확한 정보를 얻기 어렵다면, 삼성 파운드리 기술 지원팀에 직접 문의하는 것이 가장 정확하고 확실한 방법입니다. NDA (Non-Disclosure Agreement) 체결 하에 PDK를 제공받는 고객은 기술 지원을 받을 수 있습니다.
> 주의사항:
> 
> PDK는 삼성 파운드리 고객에게 기밀로 제공되는 정보이므로, 외부로 유출하거나 공유해서는 안 됩니다.
> 각 공정 노드 및 PDK 버전에 따라 제공되는 정보와 파라미터 이름이 다를 수 있습니다. 해당 PDK 버전에 맞는 문서를 확인해야 합니다.
> 요약하자면, 삼성 파운드리 PDK에서 FinFET width를 찾기 위해서는 다음 단계를 따르세요.
> 
> PDK 관련 문서를 꼼꼼히 확인합니다. (DRM, 모델 파라미터 문서, 유저 가이드 등)
> 제공되는 라이브러리의 정보 (심볼, 레이아웃, PCell 파라미터)를 살펴봅니다.
> SPICE 모델 파일을 확인하고 유효 채널 폭 관련 파라미터를 분석합니다.
> 위의 방법으로 찾을 수 없는 경우, 삼성 파운드리 기술 지원팀에 문의합니다.
> PDK 문서를 자세히 살펴보시면 FinFET 소자의 물리적 구조와 관련된 파라미터 정보를 얻으실 수 있을 것입니다.