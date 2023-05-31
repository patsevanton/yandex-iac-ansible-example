for num in {1..5000}
do
  kubectl delete pod nginx$num
done
