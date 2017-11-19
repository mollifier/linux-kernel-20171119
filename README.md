## makeとは

### デフォルトルール

```
% ls
hello.c

% make hello
cc     hello.c   -o hello

% ls
hello*   hello.c
```


### デフォルトルールを明示的に記述する

*Makefile*
```
hello: hello.c
  cc -o hello hello.c
```

```
% make hello
gcc -o hello hello.c
```

- hello : ターゲット名(出来上がりファイル名)
- hello.c : 依存ファイル
- cc ... : コマンド

「hello.cを元にして、cc...コマンドを実行して、結果としてhelloファイルを作成する」


```
# すでにあるから、何もしない
% make hello
make: `hello' is up to date.

# ターゲットを削除
% rm hello
remove hello? y

# ターゲットがないので、コマンドを実行
% make hello
cc -o hello hello.c
```


```
# 組み込みルール
% make -p | head
# GNU Make 3.81
# Copyright (C) 2006  Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# This program built for i386-apple-darwin11.3.0
make: *** No targets specified and no makefile found.  Stop.

# Make data base, printed on Sun Nov 19 13:49:33 2017
```



```
%: %.o
#  commands to execute (built-in):
    $(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@
```

### 例
hello.oがあれば、$(LINK.o) .... を実行して、helloを作る

- LINK.o = $(CC) $(LDFLAGS) $(TARGET_ARCH)
- $(LOADLIBES) と $(LDLIBS)は定義されていない

- $^
:の右側全部

- $@
target、つまり:の左側

- CC = cc

- $(LDFLAGS) $(TARGET_ARCH) は定義されていない

### 翻訳すると
cc hello.o -o hello


```
%: %.c
#  commands to execute (built-in):
    $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@
```

### 例
hello.cがあれば、$(LINK.o) .... を実行して、helloを作る

- LINK.c = $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)

### 翻訳すると
cc hello.c -o hello

## タイムスタンプをみる
%: %.c

%.c -> %をつくる
%.cと%の時刻を比較
- いっしょ、または%の方が新しい -> 何もしない
- %.cの方が新しい -> コマンド実行

### 例
1. hello.cをエディタで編集
2. hello.cの方がタイムスタンプが新しくなる
3. % make hello で、コマンドが実行される
4. 実行したら、helloの方が新しくなる

## 擬似ターゲット

```
clean:
  rm hello
```

```
.PHONY : clean help
```

PHONY にせもの

ここに書いたやつは、ターゲットじゃないよ
(作り出したいファイルではないですよ)
-> ファイルの有無とか、タイムスタンプとか関係なく、必ずコマンドを実行する

## ソースファイルを分割してみる


```
#include <stdio.h>

void print_hello(void)
{
  printf("%s\n", "Hello, world!!");
}
```

```
void print_hello(void);

int main(int argc, char *argv[])
{
  print_hello();
  return 0;
}
```


```
% make hello
cc -o hello hello.c
Undefined symbols for architecture x86_64:
  "_print_hello", referenced from:
      _main in hello-06707b.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [hello] Error 1
```

```
# これならOK
% cc -o hello hello.c print.c
```

## Cのソースファイルをそれぞれを別々にコンパイルしたい
1. hello.cをコンパイル => hello.oをつくる
2. print.cをコンパイル => print.oをつくる
3. hello.oとprint.oから、helloをつくる

```
# hello.oをつくる
% cc -c hello.c
# または
% cc -c hello.c -o hello.o

# hello.oをつくる
% cc -c print.c
# または
% cc -c print.c -o print.o

% cc -o hello hello.o print.o # ccをリンカとして使っている
```


```
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
```

```
# 初回
% make hello
cc -c hello.c -o hello.o
cc -c print.c -o print.o
cc -o hello hello.o print.o
```

```
# print.cを編集したあと
% make hello
cc -c print.c -o print.o
cc -o hello hello.o print.o
```

## おしゃれにする

```
.PHONY : clean help

%.o: %.c
  cc -c $^ -o $@

hello: hello.o print.o
  cc -o hello hello.o print.o

help:
  echo 'build hello world'

clean:
  rm hello *.o
```

