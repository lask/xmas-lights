import gpio
import gpio.adc
import pubsub

TOPIC ::= "cloud:lau/lighting"
THRESHOLD ::= 3.0

DIM ::= "dim"
LIGHT ::= "bright"

main:
  adc34 := adc. Adc
    gpio.Pin.in 34
  data := adc34.get
  result := data < THRESHOLD ? DIM : LIGHT

  print "$result {data: $(%.2f data), threshold: $THRESHOLD}"
  pubsub.publish TOPIC result
