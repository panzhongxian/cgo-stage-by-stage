set -e
tmpobjdir=_obj
mkdir -p $tmpobjdir

go tool cgo -objdir $tmpobjdir -importpath ./ export_example.go main.go

cd $tmpobjdir
gcc -c *.c -I..
gcc -c ../use_exported.c -I.. -I.
gcc -o _cgo_.o _cgo_export.o _cgo_main.o export_example.cgo2.o main.cgo2.o use_exported.o
cd - > /dev/null

go tool cgo -objdir $tmpobjdir -dynpackage main \
  -dynimport $tmpobjdir/_cgo_.o -dynout $tmpobjdir/_cgo_export.go 

go tool compile -o example2.a -p ./ -pack \
  $tmpobjdir/_cgo_gotypes.go $tmpobjdir/export_example.cgo1.go $tmpobjdir/_cgo_export.go $tmpobjdir/main.cgo1.go

cd $tmpobjdir
gcc -nostdlib -o _all.o _cgo_export.o export_example.cgo2.o main.cgo2.o use_exported.o -Wl,-r
cd - > /dev/null

go tool pack r example2.a $tmpobjdir/_all.o

go tool link -o example2 example2.a
