# Bootstrap ArgoCD

This directory contains the configuration to bootstrap ArgoCD onto the Kubernetes cluster.

## Steps

1.  **Define Namespace, ArgoCD Resources, and Ingress:**
    - The `namespace.yaml` file explicitly defines the `argocd` namespace.
    - The `argocd-ingress.yaml` file defines an Ingress resource to expose the ArgoCD UI via Traefik (using HTTPS) at `https://argocd.localhost`.
    - The `kustomization.yaml` file includes `namespace.yaml`, `argocd-ingress.yaml`, and references the official stable ArgoCD installation manifests.

2.  **Prerequisite: Update Hosts File:**
    Before applying the configuration, ensure your local machine can resolve `argocd.localhost`. Add the following line to your `/etc/hosts` file (or equivalent for your OS):
    ```
    127.0.0.1 argocd.localhost
    ```

3.  **Apply the Configuration:**
    To install ArgoCD, run the following command from the root of the repository (`dp-stack`):
    ```bash
    kubectl apply -k bootstrap
    ```
    This command uses Kustomize (via `kubectl`) to apply the manifests defined in `bootstrap/kustomization.yaml` (including the namespace, ArgoCD manifests, and the Ingress) to your currently configured Kubernetes cluster.

4.  **Apply the Root Application:**
    Once ArgoCD is running, apply the root application manifest. This tells ArgoCD to manage other applications defined in your Git repository (`argo/apps` directory).
    ```bash
    kubectl apply -f bootstrap/root-app.yaml -n argocd
    ```
