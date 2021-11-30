
import gpio
import monitor
import gpio.adc
import pubsub
import ..light_sensor.main

import solar_position show *
import device

AARHUS_LATITUDE ::= 56.162939
AARHUS_LONGITUDE ::= 10.203921

PIN2 ::= gpio.Pin.out 2

main:
  override := false
  pubsub.subscribe TOPIC --blocking=false: | msg/pubsub.Message |
    if msg.payload.to_string_non_throwing == DIM: override = true

  now := Time.now
  transitions := sunrise_sunset now.local.year now.local.month now.local.day AARHUS_LONGITUDE AARHUS_LATITUDE
  if transitions.sunrise < now < transitions.sunset:
    if not override: return

    print "Override and turn on lights."
    alive := true
    while true:
      PIN2.set 1
      alive = false
      catch:
        with_timeout (Duration --m=10):
          pubsub.subscribe TOPIC: | msg/pubsub.Message |
            alive = true
            if msg.payload.to_string_non_throwing == LIGHT: return
      if not alive: return

  midnight := Time.local --year=now.local.year --month=now.local.month --day=now.local.day+1 --h=0
  morning := transitions.sunset - (Duration --h=2)
  if midnight < now < morning:
    return

  on_duration := now < morning ? now.to morning : now.to midnight
  print "turning light on for $on_duration ($(now < morning))"
  catch:
    with_timeout on_duration:
      PIN2.set 1
      pubsub.subscribe TOPIC: | msg/pubsub.Message | null
      (monitor.Latch).get
  PIN2.set 0
