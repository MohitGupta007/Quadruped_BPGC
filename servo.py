import RPi.GPIO as GPIO
from time import sleep
GPIO.setmode(GPIO.BOARD)
GPIO.setup(07, GPIO.OUT)
pwm=GPIO.PWM(07, 50)
pwm.start(0)
f=open("angles2.txt","r");
a=f.read()
li = list(a.split("\n"))
def SetAngle(angle):
	duty = angle / 18 + 2
	GPIO.output(07, True)
	pwm.ChangeDutyCycle(duty)
	sleep(0.001)
	GPIO.output(07, False)
	pwm.ChangeDutyCycle(0)
#for i in range (0,10000):
#   SetAngle(float(li[i]))
#   sleep(0.001)
SetAngle(0)
sleep(1)
SetAngle(30)
sleep(1)
SetAngle(60)
sleep(1)
SetAngle(90)
sleep(1)
pwm.stop()
GPIO.cleanup()
