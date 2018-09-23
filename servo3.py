import RPi.GPIO as GPIO
from time import sleep
GPIO.setmode(GPIO.BOARD)
GPIO.setup(07, GPIO.OUT)
GPIO.setup(11, GPIO.OUT)
GPIO.setup(12, GPIO.OUT)
GPIO.setup(13, GPIO.OUT)
pwm1=GPIO.PWM(07, 50)
pwm2=GPIO.PWM(11, 50)
pwm3=GPIO.PWM(12, 50)
pwm4=GPIO.PWM(13, 50)
pwm1.start(0)
pwm2.start(0)
pwm3.start(0)
pwm4.start(0)
i= 0
f1=open("anglesl.txt","r");
a=f1.read()
f2=open("anglesr.txt","r");
b=f2.read()
li1 = list(a.split("\n"))
li2 = list(b.split("\n"))
def SetAngle(anglel1,angler1,anglel2,angler2):
	dutyl1 = anglel1 / 18 + 2
	dutyr1 =  angler1/ 18 + 2
	dutyl2 = anglel2 / 18 + 2
	dutyr2 =  angler2/ 18 + 2
	GPIO.output(07, True)
        GPIO.output(11, True)
        GPIO.output(12, True)
        GPIO.output(13, True)
        pwm1.ChangeDutyCycle(dutyl1)
        pwm2.ChangeDutyCycle(dutyr1)
        pwm3.ChangeDutyCycle(dutyl2)
        pwm4.ChangeDutyCycle(dutyr2)
	sleep(0.05)
	GPIO.output(07, False)
	GPIO.output(11, False)
	GPIO.output(12, False)
	GPIO.output(13, False)
	pwm1.ChangeDutyCycle(0)
        pwm2.ChangeDutyCycle(0)
	pwm3.ChangeDutyCycle(0)
        pwm4.ChangeDutyCycle(0)
	
while i<10000:
   SetAngle(float(li1[i]),float(li2[i]),float(li1[i+26]),float(li2[i+26]))
   #print(float(li[i]) float(li2[i]))
   sleep(0.0001)
   i=i+1

pwm1.stop()
pwm2.stop()
pwm3.stop()
pwm4.stop()

GPIO.cleanup()
