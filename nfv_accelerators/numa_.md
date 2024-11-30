The Kubernetes Topology Manager is a component that helps to optimize the placement of pods on nodes by considering the NUMA (Non-Uniform Memory Access) topology of the nodes. This is especially important for workloads that are sensitive to NUMA configurations, such as those requiring high-performance computing resources, where memory and CPU affinity can have significant performance impacts.

In NUMA architectures, a processor can access its local memory faster than non-local memory. Hence, for performance-sensitive applications, it's crucial to place CPU, memory, and device resources (like GPUs or NICs) in a way that minimizes access time.

### Topology Manager

The Topology Manager coordinates CPU, memory, and device assignments for pods running on a node. It ensures that these resources are aligned with the underlying hardware topology, specifically considering factors like CPU and memory locality. The primary objective is to improve the cache efficiency and reduce latency for critical workloads.

### Topology Manager Policies

The Topology Manager uses different policies to make placement decisions:

1. **None**: This policy provides no specific guidance on resource placement. It is equivalent to disabling the Topology Manager, thus allowing resources to be assigned without regard to NUMA alignment.

2. **Best-effort**: This policy makes a best effort to align resources with NUMA nodes. If alignment is not possible, it will still allow the workload to run without alignment.

3. **Restricted**: This policy allows workloads to run only if resources can be aligned with NUMA nodes. If a NUMA-aligned placement is not possible, the pod will stay in the pending state until placement becomes possible.

4. **Single-numa-node**: This policy requires that all required resources for a pod be placed on a single NUMA node. The pod is admitted only if such placement is feasible.

### Example

Consider a scenario with a Kubernetes cluster that includes nodes with multiple NUMA nodes. Let’s say you have a node with 2 NUMA nodes, each with a subset of CPUs and its own local memory.

Imagine you want to schedule a performance-sensitive application, requiring 4 CPU cores and specific memory resources that would benefit from NUMA alignment for better performance.

1. **Configure Topology Manager**:
   - Set the Topology Manager's policy to `restricted` or `single-numa-node` to ensure that resource allocation respects NUMA boundaries.
   - This can be set in the kubelet configuration file on each node:
     ```yaml
     topologyManagerPolicy: "restricted"
     ```

2. **Submit a Pod**:
   - Create a pod specification that requests multiple CPUs and optionally defines extended resources like GPUs.
   - Example YAML for the pod:

     ```yaml
     apiVersion: v1
     kind: Pod
     metadata:
       name: numademo
     spec:
       containers:
       - name: workload
         image: gcr.io/google-containers/stress:v1
         args: ["-cpus", "2"]
         resources:
           requests:
             cpu: "4"
             memory: "8Gi"
           limits:
             cpu: "4"
             memory: "8Gi"
     ```

3. **Placement**:
   - When this pod is scheduled to a node, the Topology Manager coordinates with other manager components (like the CPU Manager, Device Manager, and Memory Manager) to attempt to allocate all requested resources from a single NUMA node.
   - If the policy is `single-numa-node`, and the resources cannot be allocated from a single NUMA node, the pod will not be scheduled until such a configuration becomes available.

### 1. Check CPU NUMA Nodes

You can use the `lscpu` command to get information about CPU architecture and NUMA nodes:

```bash
lscpu
```

This will output information about your CPU, including the NUMA nodes. Look for lines that start with things like "NUMA node(s)" or "NUMA node0 CPU(s)".

### 2. Check Memory NUMA Nodes

The `numactl` command provides detailed information about memory configuration associated with NUMA nodes. You need to have the `numactl` package installed on your system:

```bash
numactl --hardware
```

This command will show you a summary detailing memory and CPU association with each NUMA node.

### 3. Check NIC NUMA Nodes

For checking the NUMA node association of network interfaces, you can examine the `/sys/class/net/` directory for each network interface:

Use the following command to find the NUMA node associated with a particular network interface, say `eth0`:

```bash
cat /sys/class/net/eth0/device/numa_node
```

A result of `-1` generally indicates that the hardware does not have a specific NUMA node association (often seen in virtual environments).

### Checking NUMA Node for All Network Interfaces

You can loop through all network interfaces and display their NUMA node information:

```bash
for iface in /sys/class/net/*; do
    iface_name=$(basename $iface)
    numa_node=$(cat $iface/device/numa_node)
    echo "Interface: $iface_name, NUMA Node: $numa_node"
done
```

### Additional Tools

- **hwloc**: This tool provides a command-line tool `lstopo` that can graphically display the hardware topology, including NUMA nodes.

  ```bash
  sudo apt-get install hwloc    # Debian/Ubuntu
  sudo yum install hwloc        # CentOS/RHEL

  lstopo
  ```

- **lshw**: Another utility that can provide detailed information about hardware configurations, though not as focused on NUMA as `numactl`.
