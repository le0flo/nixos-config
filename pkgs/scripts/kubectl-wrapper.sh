config=$1
shift
kubectl --kubeconfig ~/.config/kubectl/${config}.yaml $@
