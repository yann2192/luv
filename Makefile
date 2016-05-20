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

publish-luarocks:
	rm -rf luv-${LUV_TAG}
	mkdir -p luv-${LUV_TAG}/deps
	cp -r src cmake CMakeLists.txt LICENSE.txt README.md docs.md luv-${LUV_TAG}/
	cp -r deps/libuv deps/*.cmake deps/lua_one.c luv-${LUV_TAG}/deps/
	COPYFILE_DISABLE=true tar -czvf luv-${LUV_TAG}.tar.gz luv-${LUV_TAG}
	github-release upload --user luvit --repo luv --tag ${LUV_TAG} \
	  --file luv-${LUV_TAG}.tar.gz --name luv-${LUV_TAG}.tar.gz
	luarocks upload luv-${LUV_TAG}.rockspec --api-key=${LUAROCKS_TOKEN}
