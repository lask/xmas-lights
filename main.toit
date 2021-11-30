
import gpio
import monitor
import gpio.adc

import solar_position show *
import device

AARHUS_LATITUDE ::= 56.162939
AARHUS_LONGITUDE ::= 10.203921

PIN2 ::= gpio.Pin.out 2

main:
  now := Time.now
  transitions := sunrise_sunset now.local.year now.local.month now.local.day AARHUS_LONGITUDE AARHUS_LATITUDE
  if transitions.sunrise < now < transitions.sunset:
    return

  midnight := Time.local --year=now.local.year --month=now.local.month --day=now.local.day --h=0
  morning := transitions.sunset - (Duration --h=2)
  if midnight < now < morning:
    return

  on_duration := now < morning ? now.to morning : now.to midnight

  catch:
    with_timeout on_duration:
      PIN2.set 1
      (monitor.Latch).get
  PIN2.set 1
