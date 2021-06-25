set -e
for case_dir in `ls case* -d`; do
  cd $case_dir
  rm main -f
  go fmt *.go
  go build -o main .
  result=`stdbuf -oL ./main`
  echo "$case_dir: $result"
  cd - > /dev/null
done

echo "Success."
