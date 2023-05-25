for num in {1..5000}
do
  kubectl run nginx$num --image=nginx
done
