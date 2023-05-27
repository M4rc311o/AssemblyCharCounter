# AssemblyCharCounter
Character counter written in x86-64 assembly. Netwide Assembler(NASM) was used to assemble the code.

The aim of the project was to get more comfortable with assembly and to use as much as possible the experience I gained from decompiling various small programs.

**Use this command to assemble and link:**
```
nasm -f elf64 char_counter.asm -o char_counter.o && ld -o char_counter char_counter.o
```
