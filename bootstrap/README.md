# Bootstrap ArgoCD

This directory contains the configuration to bootstrap ArgoCD onto the Kubernetes cluster.

## Steps

1.  **Define Namespace and ArgoCD Resources:**
    - The `namespace.yaml` file explicitly defines the `argocd` namespace.
    - The `kustomization.yaml` file includes `namespace.yaml` and references the official stable ArgoCD installation manifests.

2.  **Apply the Configuration:**
    To install ArgoCD, run the following command from the root of the repository (`dp-stack`):
    ```bash
    kubectl apply -k bootstrap
    ```
    This command uses Kustomize (via `kubectl`) to apply the manifests defined in `bootstrap/kustomization.yaml` (including the namespace definition and the official ArgoCD manifests) to your currently configured Kubernetes cluster.

3.  **Apply the Root Application:**
    Once ArgoCD is running, apply the root application manifest. This tells ArgoCD to manage other applications defined in your Git repository (`argo/apps` directory).
    ```bash
    kubectl apply -f bootstrap/root-app.yaml -n argocd
    ```
