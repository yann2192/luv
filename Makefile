CFLAGS  = -Wall -Wextra -pipe -Wno-long-long -Wno-maybe-uninitialized -Wno-unused-parameter
CFLAGS += -O3 -fvisibility=hidden -DLUV_BUILD_SYSTEM
INCLUDE = -I. -I$(LADEPS)

SRC = $(shell $(FIND) src -name '*.c')
OBJ = $(patsubst %.c,%.o,$(SRC))

all: libluv.a

libluv.a: $(OBJ)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) -c $< $(CFLAGS) $(INCLUDE) -o $@

clean:
	$(RM) src/*.o libluv.a

