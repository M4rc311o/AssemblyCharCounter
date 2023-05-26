#!/bin/bash

nasm -f elf64 char_counter.asm -o char_counter.o && ld -o char_counter char_counter.o 
