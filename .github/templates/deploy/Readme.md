# Deployment Strategies

This directory contains reusable GitHub Actions workflow templates for advanced deployment patterns. These templates are designed to be called with `workflow_call` from your main workflows, supporting robust, safe, and automated deployments for Kubernetes and container-based services.

## Strategies Overview

### 1. Rolling Deployment (`deploy.yml`)
- **What:** Gradually replaces old versions of pods with new ones.
- **When to use:** For most production deployments where downtime must be minimized.
- **How:** Updates pods one by one or in batches.

### 2. Automated Rollback (`deploy-with-rollback.yml`)
- **What:** Automatically reverts to the previous version if a health check fails after deployment.
- **When to use:** When you want to ensure that failed deployments do not impact production.
- **How:** Runs a health check after deployment, triggers `kubectl rollout undo` if unhealthy.

### 3. Canary Deployment (`canary-deploy.yml`)
- **What:** Gradually shifts a small percentage of traffic to the new version before promoting it fully.
- **When to use:** When you want to test new releases in production with real traffic but limited risk.
- **How:** Deploys the new version alongside the old, adjusts traffic weight as defined by your ingress/controller/service mesh.

### 4. Blue-Green Deployment (`blue-green-deploy.yml`)
- **What:** Runs two production environments ("blue" and "green") and switches all traffic from blue to green after verifying the new version.
- **When to use:** For zero-downtime deployments and fast rollbacks.
- **How:** Deploys to "green", health-checks, then updates service selectors to shift all traffic.

### 5. Shadow Deployment (`shadow-deploy.yml`)
- **What:** Deploys a new version in parallel and mirrors real traffic to it, without impacting production.
- **When to use:** For testing new features in production-like conditions without user impact.
- **How:** Uses service mesh or ingress to mirror traffic to the shadow deployment.

---

## Usage

Call these templates from your main workflow using `uses: ./.github/templates/deploy/<template_name>.yml` and pass the required inputs.

Example (in a workflow):
```yaml
jobs:
  deploy:
    uses: ./.github/templates/deploy/deploy-with-rollback.yml
    with:
      service-name: my-app
      image: ghcr.io/my-org/my-app
      tag: ${{ github.sha }}
      healthcheck-url: "https://my-app.example.com/healthz"
```

## Health Check Endpoint Example

Your service should expose a health check endpoint that returns HTTP 200 when healthy.
- **Path:** `/healthz` or `/health`
- **Method:** GET
- **Response:** 200 OK if healthy, non-200 if not

Sample implementation (Node.js/Express):

```javascript
app.get('/healthz', (req, res) => {
  res.status(200).send('OK');
});
```

Sample implementation (Python/Flask):

```python
@app.route('/healthz')
def health():
    return "OK", 200
```

Sample implementation (Go):

```go
http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("OK"))
})
```

---

**Note:** For canary, blue-green, and shadow deployments, you may need to configure your ingress controller or service mesh (e.g., Istio, Linkerd, NGINX) to handle traffic shifting or mirroring.

---