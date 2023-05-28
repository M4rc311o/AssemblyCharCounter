# AssemblyCharCounter
Character counter written in x86-64 assembly. Netwide Assembler(NASM) was used to assemble the code.

Just a quick and simple character counter made to practise assembly basics.

**Use this command to assemble and link:**
```
nasm -f elf64 char_counter.asm -o char_counter.o && ld -o char_counter char_counter.o
```
