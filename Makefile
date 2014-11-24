
PROJECT=miniblink

AS=arm-none-eabi-as
LD=arm-none-eabi-ld
OBJCOPY=arm-none-eabi-objcopy

OBJECTS=miniblink.o

rom.hex: $(PROJECT).out
	$(OBJCOPY) -O ihex $(PROJECT).out $(PROJECT).hex

$(PROJECT).out: $(OBJECTS)
	$(LD) -v -T stm32f4-discovery.ld -nostartfiles -o $(PROJECT).out $(OBJECTS)

.s.o:
	$(AS) -mthumb -mcpu=cortex-m4 $< -o $@

clean:
	rm -f *.o *.out *.hex *~

flash: rom.hex
	openocd -f interface/stlink-v2.cfg \
	        -f board/stm32f4discovery.cfg \
	        -c "init" -c "reset init" \
	        -c "flash write_image erase $(PROJECT).hex" \
	        -c "reset" \
	        -c "shutdown" 

