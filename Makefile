.PHONY : clean help

hello: hello.c
	cc -o hello hello.c

help:
	echo 'build hello world'

clean:
	rm hello

