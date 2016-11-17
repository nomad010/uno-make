rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

INC=
LIBS=-lm
MCU=-mmcu=atmega328p
PORT=/dev/cuaU0 # FreeBSD
ifeq ($(shell uname),Linux)
	PORT=/dev/ttyACM0
endif
CPU_SPEED=-DF_CPU=16000000UL
FLAGS=$(MCU) $(CPU_SPEED) -Os -w -Wl,--gc-sections -ffunction-sections -fdata-sections

CXX=avr-g++
CXX_SRC= $(call rwildcard,,*.cpp)
CXX_OBJ=$(patsubst src/%.cpp, obj/%.o, $(CXX_SRC))
CXX_DEP=$(patsubst src/%.cpp, dep/%.o, $(CXX_SRC))

CC=avr-gcc
C_SRC= $(call rwildcard,,*.c)
C_OBJ=$(patsubst src/%.c, obj/%.o, $(C_SRC))
C_DEP=$(patsubst src/%.c, dep/%.o, $(C_SRC))




default: build upload

-include $(CXX_DEP) $(C_DEP)

build: main.hex

main.hex: main.elf
	avr-objcopy -O ihex $< $@

main.elf: $(C_OBJ) $(CXX_OBJ)
	$(CXX) $(FLAGS) $(INC) $^ -o $@ $(LIBS)

upload:
	avrdude -V -F -p m328p -c arduino -b 115200 -Uflash:w:main.hex -P$(PORT)

clean:
	rm -f $(C_OBJ) $(CXX_OBJ) main.elf main.hex $(CXX_DEP) $(C_DEP)
	rm -rf dep
	rm -rf obj

obj/%.o: src/%.cpp
	@mkdir -p `dirname $@`
	$(CXX) $(FLAGS) $(INC) -c -o $@ $<
	@mkdir -p `dirname $(subst obj/,dep/,$@)`
	@$(CXX) -MM $(FLAGS) $(INC) $< > $(subst obj/,dep/,$@)
	@sed -i -e 's|.*:|$@:|' $(subst obj/,dep/,$@)
	@sed -i -e 's|.d:|.o:|' $(subst obj/,dep/,$@)
	@sed -i -e 's|^dep/|obj/|' $(subst obj/,dep/,$@)

obj/%.o: src/%.c
	@mkdir -p `dirname $@`
	$(CC) $(FLAGS) $(INC) -c -o $@ $<
	@mkdir -p `dirname $(subst obj/,dep/,$@)`
	@$(CC) -MM $(FLAGS) $(INC) $< > $(subst obj/,dep/,$@)
	@sed -i -e 's|.*:|$@:|' $(subst obj/,dep/,$@)
	@sed -i -e 's|.d:|.o:|' $(subst obj/,dep/,$@)
	@sed -i -e 's|^dep/|obj/|' $(subst obj/,dep/,$@)