
*.inc "/home/yh1000/pdk/asap7_pdk_r1p7/models/hspice/7nm_TT_160803.pm"
.inc "temp_model/7nm_TT_160803.pm"

* 전원 공급
Vdd vdd 0 1.0

* 입력 신호
Vin in 0 pulse (0 1 0 100p 100p 500p 1n)

* 첫 번째 인버터
M1 out1 in vdd vdd pmos_rvt l=7n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
M2 out1 in 0 0 nmos_rvt l=7n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n

* 출력 로드 (선택 사항)
Cload out1 0 1f

* 시뮬레이션 설정
.tran 1p 2n
.options post

.control
    run
    plot in out
.endc

* 출력

.end
