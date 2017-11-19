.PHONY : clean help

hello.o: hello.c
	cc -c hello.c -o hello.o

print.o: print.c
	cc -c print.c -o print.o

hello: hello.o print.o
	cc -o hello hello.o print.o

help:
	echo 'build hello world'

clean:
	rm hello *.o

