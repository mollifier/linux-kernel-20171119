.PHONY : clean help

# HOGEFLAGS = -O
# 値の定義は終わって、HOGEFLAGSの値を参照するときに右辺を展開する

# :=は、単純展開変数(Simply expanded variables)
# HOGEFLAGS := -O
# HOGEFLAGSの値を定義するときに右辺を展開する

SRCS := $(wildcard *.c)
# $(SRCS)の%.cを%.oに置き換える
OBJS := $(patsubst %.c,%.o,$(SRCS))

%.o: %.c
	cc -c $^ -o $@

hello: $(OBJS)
	cc -o hello $(OBJS)

help:
	echo "SRCS = $(SRCS)"
	echo "OBJS = $(OBJS)"
	echo 'build hello world'

clean:
	rm hello *.o

