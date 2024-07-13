AS = /usr/local/bin/nasm
LD = /usr/bin/ld

CCFLAGS = -c -O0
ASFLAGS = -f elf64
LDFLAGS = -static -z noexecstack
LIBPATH = -L /lib/gcc/x86_64-pc-linux-gnu/13.2.1 -L /lib
OBJPATH = /usr/lib

LIBS = -lgcc -lgcc_eh -lc -lm

PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

SRCS = lab.c image_scale.c image_scale_asm.s
HEAD = image_scale.h
OBJS = lab.o image_scale.o image_scale_asm.o

EXE = lab

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(OBJS): $(HEAD)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@

.c.o:
	$(CC) $(CCFLAGS) $< -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@
