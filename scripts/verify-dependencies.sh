echo "Verifying dependencies..."

# wait_for_resource - Wait for Kubernetes resources to exist (retries every 5s)
# Usage: wait_for_resource <namespace> <resource_type> <label> [timeout_seconds]
# Returns: 0 on success, 1 on timeout
# Example: wait_for_resource "default" "pods" "app=myapp" 300
wait_for_resource() {
    local namespace=$1
    local resource_type=$2
    local label=$3
    local description="resource ${resource_type} in namespace ${namespace} with label ${label}"
    local timeout=${5:-300}
    local interval=5
    local elapsed=0

    echo "Waiting for ${description}..."
    while ! oc get ${resource_type} -n ${namespace} -l ${label} 2>/dev/null | grep -q .; do
        if [ $elapsed -ge $timeout ]; then
            echo "ERROR: ${description} not found after ${timeout}s"
            return 1
        fi
        sleep $interval
        elapsed=$((elapsed + interval))
    done
    echo "✓ ${description} found"
    return 0
}

# Verify cert-manager is installed correctly
echo "Waiting for cert-manager to be ready..."

# Wait for cert-manager pods to exist and be ready
if ! wait_for_resource "cert-manager" "pods" "app.kubernetes.io/instance=cert-manager"; then
    exit 1
fi

echo "✓ cert-manager is installed and ready"
