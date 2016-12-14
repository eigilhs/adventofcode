say Q:to/END/;
.text
.globl main
main:
	xor %rax, %rax
	xor %rbx, %rbx
	xor %rcx, %rcx
	xor %rdx, %rdx
END

my $i = 0;

for (lines) {
    print "L{$i++}:\t";
    when / ^ cpy \h (\w+) \h (\w+) / {
        if $0.Int {
            say "mov \$$0, %r$1x"
        } else {
            say "mov %r$0x, %r$1x"
        }
    }
    when / ^ inc \h (\w+) / {
        say "inc %r$0x"
    }
    when / ^ dec \h (\w+) / {
        say "dec %r$0x"
    }
    when / ^ jnz \h (\w+) \h (\-?\d+) / {
        if $0.Int {
            say "jmp L{$i + $1 - 1}"
        } else {
            say "test %r$0x, %r$0x";
            say "\tjnz L{$i + $1 - 1}"
        }
    }
}

say Q:to/END/
	mov %rax, %rsi
	mov $fmt, %rdi
	xor %rax, %rax
	call printf
	xor %rax, %rax
	ret
fmt:	.asciz "%d\n"
END
