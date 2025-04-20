# SPF

[link](https://en.wikipedia.org/wiki/Standard_Parasitic_Exchange_Format)


```
*DSPF 1.0
*DIVIDER /
*DELIMITER :
*BUS_DELIMITER [ ]

*|GROUND_NET NetName

.SUBCKT

*NET NetName NetCap
*|I(InstancePinName InstanceName PinName PinType PinCap X Y)
*|P(PinName PinType PinCap X Y)
*|S(SubNodeName X Y)

.ENDs

.END
```