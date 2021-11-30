import gpio
import gpio.adc
import pubsub

TOPIC ::= "cloud:lau/lighting"
THRESHOLD ::= 2.5

main:
  adc34 := adc. Adc
    gpio.Pin.in 34
  data := adc34.get
  result := data < THRESHOLD ? "dim" : "bright"

  print "$result {data: $(%.2f data), threshold: $THRESHOLD}"
  pubsub.publish TOPIC result
