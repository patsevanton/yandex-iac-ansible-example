for num in {1..5000}
do
  echo $num
  kubectl delete svc nginx$num
done
