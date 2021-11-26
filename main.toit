
import gpio 
import monitor

import solar_position show *

AARHUS_LATITUDE ::= 56.162939
AARHUS_LONGITUDE ::= 10.203921

main:
  pin2 := gpio.Pin 2
  pin2.config --output

  while true:
    now := Time.now
    ti := now.local
    transitions := sunrise_sunset ti.year ti.month ti.day AARHUS_LONGITUDE AARHUS_LATITUDE
    midnight := Time.local --year=ti.year --month=ti.month --day=ti.day --h=0
    six_am := Time.local --year=ti.year --month=ti.month --day=ti.day --h=6
    if transitions.sunrise + (Duration --h=2) < now < transitions.sunset or midnight < now < six_am:
      pin2.set 0
    else:
      pin2.set 1
    sleep --ms=60_000
