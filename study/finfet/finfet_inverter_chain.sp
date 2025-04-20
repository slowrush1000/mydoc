* FinFET 인버터 체인 예제

* 라이브러리 포함 (실제 모델 파일 경로로 수정 필요)
.include 'finfet_model_parameter.lib'

* 전원 공급
Vdd vdd 0 1.0

* 입력 신호
Vin in 0 pulse (0 1 0 100p 100p 500p 1n)

* 첫 번째 인버터
M1 out1 in vdd vdd pmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
M2 out1 in 0 0 nmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n

* 두 번째 인버터
M3 out2 out1 vdd vdd pmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
M4 out2 out1 0 0 nmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n

* 세 번째 인버터
M5 out3 out2 vdd vdd pmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n
M6 out3 out2 0 0 nmos l=10n nfin=4 nf=2 ad=10p as=10p pd=20n ps=20n

* 출력 로드 (선택 사항)
Cload out3 0 1f

* 시뮬레이션 설정
.tran 1p 2n
.options post

* 출력
.plot tran v(in) v(out1) v(out2) v(out3)
.end