# Shutdown

```shell
talosctl --talosconfig=./talosconfig  -e 192.168.1.102 -n 192.168.1.102 shutdown --force=true
```

# Reboot

```shell
talosctl --talosconfig=./talosconfig  -e 192.168.1.102 -n 192.168.1.102 reboot --wait
```

# Upgrade

There is an option to this command: --preserve, which will explicitly tell Talos to keep ephemeral data intact. In most cases, it is correct to let Talos perform its default action of erasing the ephemeral data. However, for a single-node control-plane, make sure that --preserve=true

also use the `--stage` flag to apply the update after reboot

```shell
talosctl --talosconfig=./talosconfig upgrade --preserve=true --stage --nodes 192.168.1.102 --wait --debug --image ghcr.io/siderolabs/installer:<NEW VERSION>
```

# Reset the node to its initial state

```shell
talosctl --talosconfig=./talosconfig reset --graceful=false --reboot=true --nodes 192.168.1.102 --debug
```

# Initial setup

Create `patch.yaml`
```yaml
cluster:
  network:
    cni:
      name: none
  proxy:
    disabled: true
```

Create configs
```shell
talosctl gen config cluster1 https://192.168.1.102:6443 --config-patch @patch.yaml
```

Edit the generated config file `controlplane.yaml` to set `allowSchedulingOnControlPlanes: true`
Edit the generate `talosconfig.yaml` file to include all the endpoint ip addresses.


Setup nodes
```shell
talosctl apply-config --insecure -n 192.168.1.102 --file controlplane.yaml
```

## Bootstrap K8s
```shell
talosctl bootstrap --nodes 192.168.1.102 --endpoints 192.168.1.102 --talosconfig=./talosconfig
```

Merge the kubeconfig 
```shell
talosctl kubeconfig --nodes 192.168.1.102 --endpoints 192.168.1.102 --talosconfig=./talosconfig
```


## Install Cilium
Add helm repo
```shell
helm repo add cilium https://helm.cilium.io/
helm repo update
```

Install - extra helm settings from here https://blog.stonegarden.dev/articles/2023/12/migrating-from-metallb-to-cilium/
```shell
helm install \
    cilium \
    cilium/cilium \
    --version 1.15.1 \
    --namespace kube-system \
    -f ./cilium/values.yaml

#or

helm install \
    cilium \
    cilium/cilium \
    --version 1.15.1 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set=kubeProxyReplacement=true \
    --set=securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set=securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set=cgroup.autoMount.enabled=false \
    --set=cgroup.hostRoot=/sys/fs/cgroup \
    --set=k8sServiceHost=localhost \
    --set=k8sServicePort=7445
```