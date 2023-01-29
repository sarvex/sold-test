#!/bin/bash
. $(dirname $0)/common.inc

cat <<EOF | $CC -o $t/a.o -c -xc -
int arr[5] = { 1, 2, 3, 4, 5 };
EOF

$CC --ld-path=./ld64 -shared -o $t/b.dylib $t/a.o

cat <<EOF | $CC -o $t/c.o -c -xc -
#include <stdio.h>

extern int arr[5];

int *p1 = arr + (1LL << 40);

int main() {
  printf("%d %d %d\n", arr[0], *(p1 - (1LL << 40)));
}
EOF

$CC --ld-path=./ld64 -o $t/exe $t/c.o $t/b.dylib -Wl,-fixup_chains
$t/exe
