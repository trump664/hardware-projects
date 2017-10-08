#!/usr/bin/python

from time import sleep
from matrix_keypad import RPi_GPIO
 
kp = RPi_GPIO.keypad(columnCount = 3)
 
def digit():
    # Loop while waiting for a keypress
    r = None
    while r == None:
        r = kp.getKey()
    return r 
 
print "Please enter a 4 digit pin: ",

d1 = digit()
print d1,
sleep(0.5)
 
d2 = digit()
print d2,
sleep(0.5)
 
d3 = digit()
print d3,
sleep(0.5)
 
d4 = digit()
print d4
 
# printing out the assembled 4 digit code.
print "Your new pin is: %s%s%s%s "%(d1,d2,d3,d4) 
