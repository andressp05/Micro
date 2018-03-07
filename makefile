all: pract1a.exe pract1b.exe pract1c.exe

pract1a.exe: pract1a.obj
	tlink /v pract1

pract1a.obj: pract1a.asm
	tasm /zi pract1a.asm

pract1b.exe: pract1b.obj
	tlink /v pract1b

pract1b.obj: pract1b.asm
	tasm /zi pract1b.asm

pract1c.exe: pract1c.obj
	tlink /v pract1c

pract1c.obj: pract1c.asm
	tasm /zi pract1c.asm



