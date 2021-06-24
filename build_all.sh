set -e
for stage_dir in `ls stage* -d`; do
  cd $stage_dir
  rm main -f
  go fmt *.go
  go build -o main .
  result=`stdbuf -oL ./main`
  echo $stage_dir ":" $result
  cd - > /dev/null
done

echo "Success."
