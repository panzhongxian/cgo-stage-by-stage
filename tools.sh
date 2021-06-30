set -e

function build_stage1() {
  for case_dir in `ls stage1-* -d`; do
	cd $case_dir
	rm main -f
	go fmt *.go
	go build -o main .
	result=`stdbuf -oL ./main`
	echo "$case_dir: $result"
	cd - > /dev/null
  done
}

function build_stage2() {
  for case_dir in `ls stage2-* -d`; do
	cd $case_dir
	sh build.sh
	elf_file=`file ./*| grep ELF| awk -F":" '{print $1}'`
	echo "$case_dir: `stdbuf -oL $elf_file`"
	cd - > /dev/null
  done
}

function build_all() {
  build_stage1
  build_stage2
  echo "Success."
}

function usage() {
  cat << EOF
Usage: ./tools.sh <build|clean>
EOF
}

if [ $# -ne 1 ]; then
     usage;
fi


if [ "$1" == "build" ]; then
  build_all;
elif [ "$1" == "clean" ]; then
  find . -name _obj -o -name "*.a" -exec rm -rf {} \;
  find . -exec file {} \; | grep -i elf | awk -F':' '{print $1}' | xargs rm -rf
fi
