# tinylight
This is a tiny, battery-powered indicator light, optimized for long battery life:

![Photo of a finished light](https://github.com/seanboyce/tinylight/blob/main/tinylight_IC.JPG)

# BOM (per light)

1x ATTINY10 (36 cents for a CPU? Truly, we live in an age of wonders)

1x 0402 RED SMT LED

1x CR2032 battery holder

1x CR2032 battery

Optional:

1x strong disk magnet -- this will stick to the CR2032 battery. Now your light can stick to magnetic surfaces easily!

2x 3-pin 2.54mm headers (likely you will just buy a big 2.54mm header set and break off two 3-pin pieces). These are handy for setting up a programmer.

# So it's... just a battery-powered light?
Yes! It's very good at doing its job though. If you just do the obvious thing and connecte a battery + resistor + LED, the CR2032 battery will run out in 3 or 4 months.

By applying mildly unreasonable amounts of engineering, it now appears brighter and lasts at least two years. I don't know exactly how long , the first one I made is still running. My slide rule indicates an estimated battery life of around 3.5 years.

# What is it for?
Some older people were talking about getting up at night feeling a bit disoriented and needing to go to the bathroom, and bumping into furniture and so on. Seemed like few dim indicator lights could help. Falling when you're older is no joke.

# How much can you optimize a light?
I'm glad you asked! It turns out, quite a bit.

In the naive case, you connect an LED to a power source and a resistor. The power source causes current to flow through the LED light, limited by the resistor, and fiat lux! You're done. However...

First, power is lost in the resistor (square of the current times resistance). So, out it goes. Thankfully, it turns out when you remove the current-limiting resistor in an LED, the current does NOT in fact go to infinity as per the simple equation we might learn in high school. The relationship between current and voltage across a diode is nonlinear past the voltage drop -- but it's some finite number of electrons. So if we only turn the LED on for a very short time (microseconds), the amount of current transferred per unit of time will still be within specifications. So that's what we'll do. (Also, the maximum output current of a GPIO on the ATTINY10 is higher than the LED maximum, but not *super* high)

Next, your eye (like a video camera) does not have infinite speed. Our vision has persistence -- e.g. if you look at a light that's flashing fast enough, it will not appear to be flashing at all. So if we emit a burst of light for a tiny amount of time (microseconds), we can time it so that the light will appear much brighter than it actually is.

Finally, we can also make the light visibly flash, having distinct on and off times, to help attract attention. It's actually going to be few-microsecond flashes seperated by some hundred milliseconds or so.

# What controls all this?

An ATTINY10 MCU. That's right, a whole computer. Although it's half the size of a grain of rice, and probably faster than what took the Apollo Program to the Moon the first time.

It has a lot of great power-saving features. We'll be using the watchdog timer extensively. To make sure that we dont waste time (time is power!), we'll write up some code in Assembler. It's a very small program though, so this will be super easy. I'll provide you with both the Assembler and hex file here.

# How do I use it?

You'll need to make or order circuit boards. I've included a PCB drawn in KiCAD -- this is tiled and includes V-Cuts, so you can snap them apart to get many units. Every manufacturer has different standards for V-Cuts! I've tried to adhere to what JLBPCB uses. This PCB layout should get you 120 units from a standard order of 5 boards.

Note that the boards have holes you can add a header to. This will be important for programming, and lets you use and extra PCBs as cute little ATTINY10 development boards.

# How do I get code on to the chip?

You'll need a TPI programmer. You can use the Atmel-ICE, but thankfully an Arduino can be coerced to work too: https://github.com/james-tate/Arduino-TPI-Programmer

A useful approach is to solder headers onto a board and connect up your arduino. Then, place an attiny10 on top of the pads with tweezers. Press it in place firmly with your finger, and then initiate programming. This works surprisingly well, but mind polarity or you will get SOT23-6 shaped burns on your finger.

You can program the hex file using the Arduino method. If you want to modify the Assembler, you'll need Microchip Studio or another assembler to assemble the hex file. Then the new hex file can be burned in to the ATTINY10 with an Arduino.

If you have an AVR-ICE, you can just work with Microchip Studio. Although like most software for hardware engineers, it's pretty buggy. Save your work often!

# How do I solder it!? It's so small!

It's deceptively easy with solder paste and a hot air rework station. The type of solder paste in a syringe is usually good (and lasts longer before drying out, less waste!). Squeeze some out onto a plastic sheet, then use a spare (through-hole) resistor to pick up a little of the paste and dab it onto the pads. There should be a visible mound of paste on each pad, not just a thin coat. A bit of a mess is OK, but if in doubt you can wipe it off with a tissue and try again.

Then drop the components in place with tweezers and heat up evenly. The surface tension from the solder will make every part 'snap' into place. It's really fun to watch. You'll quickly learn that you don't have to be so accurate with the paste :)

You can hand-solder it too. Just tin one pad for each part, then heat up that pad to melt the solder. Push the relevant part into place with tweezers, remove heat. That will hold the part in place. Apply solder to the other pads, then once more to the first pad. It won't look as pretty as solder paste, but it's easier than it looks.

# Does it have to be red?

Sort of? Red LEDs have the lowest voltage drop, so it's by far the most efficient in our case. I've tested with orange LEDs too. While less bright, it still basically works. Yellow might be tolerable too. Anything higher frequency than that, might not be practical. Certainly it will take up more battery power for a given brightness.
