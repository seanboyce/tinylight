.CSEG ; First, we set up our interrupt vectors
.ORG 0 ;These have to be in the first few bytes of program memory
rjmp RESET ; Reset Handler -- useful to define in case of unexpected reset condition
rjmp RESET ; IRQ0 Handler(not used so point it to RESET)
rjmp RESET ; PCINT0 Handler(not used so point it to RESET)
rjmp RESET ; Timer0 Capture Handler(not used so point it to RESET)
rjmp RESET ; Timer0 Overflow Handler(not used so point it to RESET)
rjmp RESET ; Timer0 Compare A Handler(not used so point it to RESET)
rjmp RESET ; Timer0 Compare B Handler(not used so point it to RESET)
rjmp RESET ; Analog Comparator Handler(not used so point it to RESET)
rjmp WDT ; Watchdog Interrupt Handler -- used to flash the light!

RESET:

LDI r16, (1<<PRADC) | (1<<PRTIM0); disable peripherals to save power
OUT PRR, r16

;define some constants for convenience
LDI r18, 0xFF
LDI r17, 0x00
OUT PUEB, r17 ; make sure pullups are off, they waste power

;setup output and make sure it's low and the port is set for output
OUT DDRB, r18
OUT PORTB, r17

;setup watchdog timer. Watchdog interrupt enable, watchdog reset disable.

;uncomment next line to flash every 64 milliseconds (4096 CPU cycles) -- appears as a mostly constant light
;LDI r16, (0<WDP0) | (1<<WDP1) | (0<<WDP2) | (0<<WDP3) | (0<<WDE) | (1<<WDIE) 

;uncomment next line to flash every 128 milliseconds (8192 CPU cycles) -- appears as a mostly flashing light
LDI r16, (1<WDP0) | (1<<WDP1) | (0<<WDP2) | (0<<WDP3) | (0<<WDE) | (1<<WDIE) 

OUT WDTCSR, r16

;enable interrupts now that everything is set up
SEI 

;sleep mode power down -- the watchdog timer will still be running
LDI r16, (1<<SE) | (0<<SM0) | (1<<SM1) | (0<<SM2)
OUT SMCR, r16

;Set up a loop that just turns off the light and powers down the MCU
loop:
SLEEP
OUT PORTB, r17 ;first instruction that will run when returning from interrupt turns off the light
RJMP loop

;Will wake from sleep and perform the below (WDT is the interrupt vector for the watchdog timer). The number of NOP cycles (no-operation) sets the brightness. We could use a timer but it's not like we're running low on program flash and it doesn't really save any measurable amount of power to use a proper timer.
;12x NOP normal brightness, 18x NOP extra bright

WDT:
OUT PORTB, r18
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
RETI ; return to loop
