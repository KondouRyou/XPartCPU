C_SRC = $(sort $(wildcard *.c))
OBJ = $(patsubst %.c,%.o,$(C_SRC))
all: $(OBJ)

%.o : %.c
	${GCC} ${CFLAG} -c $< #-fno-stack-protector

.PHONY : clean
clean :
	$(shell rm *.o 2>/dev/null)