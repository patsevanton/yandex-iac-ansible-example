for num in {1..5000}
do
  kubectl expose pod nginx$num  --port 80 --target-port 8080
done
