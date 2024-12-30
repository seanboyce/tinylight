# tinylight
This is tiny, battery-powered indicator light, optimized for long battery life.

# So it's... just a battery-powered light?
Yes! It's very good at doing it's job though. If you just do the obvious thing and connecte a battery + resistor + LED, the CR2032 battery will run out in 3 or 4 months.

By applying unreasonable amounts of engineering, it now appears brighter and lasts at least two years. I don't know exactly how long , the first one I made is still running. My slide rule indicates an estimated battery life of around 3.5 years.

# What is it for?
Some older people were talking about getting up at night feeling a bit disoriented and needing to go to the bathroom, and bumping into furniture and so on. Seemed like few dim indicator lights could help.

# How much can you optimize a light?
I'm glad you asked! It turns out, quite a bit.

In the naive case, you connect an LED to a power source and a resistor. The power source causes current to flow through the LED light, limited by the resistor, and fiat lux! You're done.

First, power is lost in the resistor (square of the current times resistance). So it's got to go. Thankfully, it turns out when you remove the current-limiting resistor in an LED, the current does NOT in fact go to infinity as per the simple equation we learn in high school. The relationship between current and voltage across a diode is nonlinear past the voltage drop -- but it's some finite number of electrons. So if we only turn the LED on for a very short time (microseconds), the amount of current transferred per unit of time will still be within specifications. So that's what we'll do.

However, your eye (like a video camera) does not have infinite speed. Our vision has persistence -- e.g. if you look at a light that's flashing fast enough, it will not appear to be flashing at all. So if we emit a burst of light for a tiny amount of time (microseconds), we can time it so that the light will appear much brighter than it actually is.

Finally, we can also make the light visibly flash, having disting on and off times, to help attract attention.

# What controls all this?

An ATTINY10 MCU. That's right, a whole computer. Although it's half the size of a grain of rice, and probably more powerful than what took the Apollo Program to the Moon the first time.

It has a lot of great power-saving features. We'll be using the watchdog timer extensively. To make sure that we dont waste time (time is power!), we'll write up some code in Assembler. It's a very small program though, so this will be super easy.
