CFLAGS = -no-pie
OBJS = day12_1 day12_2

.PHONY: clean 1 2

1 2: %: day12_%
	./$<

$(OBJS): %: %.p6 input
	perl6 $^ | cc -no-pie -o $@ -xassembler -

clean:
	$(RM) $(OBJS)
