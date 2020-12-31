; *******************************
;    Filename: PIR debounce FINAL 		
;    Date: 			
;    File Version: 	
;    Written by: Paulo Caetano		
;    Function: Led PIR controller		
;    Last Revision: 10/09/2017
;    Target PICAXE: 08M2
; ******************************* 

#picaxe 08M2
#no_end

symbol PIR = pin3  	'Assigns pin3 to PIR.  Need to be a variable, not a constant!
symbol  = 4     	'Assigns pin4 to LED
symbol PIRWarmup = b0	'Byte for tracking warmup loop
symbol TIMER = b1  	'Byte for debounce timer
symbol Seconds = s_w1

; Prop time values 
symbol WarmupTime = 40	'Change this value for different PIR warmup time.  Time in seconds.
symbol ResetTime = 5000	'Change this for reset time. 1000 = 1 second.
symbol  LightOnTimeSeconds = 36000
symbol WaitCounter = 50;

Init:
	let  Seconds = 0
	for PIRWarmup = 1 to WarmupTime				' Define loop for PIR calibration time
	pause 1000						    		' Wait 1 second
	next PIRWarmup								' End of loop

Main: 
        let Seconds = 0
	TIMER = 0 									'Reset Timer byte
	
Check_PIR:	
	'debug 
        readadc C.1, b2	
	pause 5				        					'Brief pause on the checking loop
	TIMER = TIMER + 5 * PIR						     'Add 5 to byte 0 and multiply by value of PIR.  Movement = high
	if pinC.2 = 1 then Prop_Trigger                      		     ' push button trigger
	if TIMER < 10 or b2 > 50 then Check_PIR  			 'If you leave the debug statement in, this should be 10
Prop_Trigger:
	
	high LED 								               'Turn on lights
Count_Time:			
	pause 100                                                                            'Lights on timer loop
	inc Seconds
	if pinC.2 = 1 then Force_Turn_Off
	if Seconds < LightOnTimeSeconds then Count_Time
	low LED	
	''pause ResetTime		'Allows PIR to settle down again.  Change ResetTime if needed.
	goto Main
	
Force_Turn_Off:
	low LED
	
Wait_For_Zero:
	pause 100
	if pinC.2 = 1 then Wait_For_Zero                                 
	let Seconds = 0			 ' Wait for 3 seconds before starting the PIR detection
Count_Time_2:	
	pause 100
	inc Seconds
	if Seconds < WaitCounter then Count_Time_2				        					
	goto Main