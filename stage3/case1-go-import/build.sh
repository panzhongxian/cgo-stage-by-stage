set -e
tmpobjdir=_obj
mkdir -p $tmpobjdir

env CGO_LDFLAGS=-lm go tool cgo -objdir $tmpobjdir -importpath ./ import_example.go

cd $tmpobjdir
gcc -c *.c
gcc -o _cgo_.o _cgo_export.o _cgo_main.o import_example.cgo2.o -lm
cd - > /dev/null

go tool cgo -objdir $tmpobjdir -dynpackage main \
  -dynimport $tmpobjdir/_cgo_.o -dynout $tmpobjdir/_cgo_import.go

go tool compile -o example1.a -p ./ -pack \
  $tmpobjdir/_cgo_gotypes.go $tmpobjdir/import_example.cgo1.go $tmpobjdir/_cgo_import.go main.go

cd $tmpobjdir
gcc -nostdlib -o _all.o _cgo_export.o import_example.cgo2.o -Wl,-r
cd - > /dev/null

go tool pack r example1.a $tmpobjdir/_all.o

go tool link -o example1 example1.a
