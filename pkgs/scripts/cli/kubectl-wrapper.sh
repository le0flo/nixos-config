config="$HOME/.config/kubectl/$1.yaml"

if [ -f $config ]; then
    shift
    kubectl --kubeconfig $config $@
else
    kubectl $@
fi
