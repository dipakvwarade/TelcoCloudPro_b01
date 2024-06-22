# What is etcd?

etcd is a strongly consistent, distributed key-value store that provides a reliable way to store data that needs to be accessed by a distributed system or cluster of machines
It gracefully handles leader elections during network partitions and can tolerate machine failure, even in the leader node! 


| Fact # | Aspect               | Description                                                                                             |
|--------|----------------------|---------------------------------------------------------------------------------------------------------|
| 1      | Definition           | ETCD is a distributed key-value store used by Kubernetes to store all its cluster data.                 |
| 2      | Role in Kubernetes   | It serves as the primary datastore for Kubernetes, storing the entire state and configuration of the cluster. |
| 3      | Data Model           | Stores data in a hierarchical structure as key-value pairs.                                             |
| 4      | High Availability    | Achieved through clustering; ETCD should be run as a cluster of odd numbers of nodes.                   |
| 5      | Raft Consensus       | Uses the Raft consensus algorithm to ensure consistency across the distributed nodes.                    |
| 6      | Backup Importance    | Regular backups of ETCD are crucial for disaster recovery.                                              |
| 7      | Interaction          | Kubernetes components interact with ETCD through the API server.                                        |
| 8      | Security             | Supports TLS to secure communications and can be configured to require client certificates for access.  |
| 9      | Performance          | Performance can be impacted by network latency, disk I/O, and CPU.                                      |
| 10     | Scalability          | Suitable for scaling, but requires careful management of node numbers and sizes.                        |


To interact with ETCD in a Kubernetes KIND (Kubernetes IN Docker) cluster, you typically need to access the ETCD server used by the Kubernetes API server. Below are the steps to achieve that:

### Prerequisites
- [Install KIND](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Install etcdctl](https://etcd.io/docs/v3.5/install/)

### Step-by-Step Guide to Interact with ETCD in KIND Cluster

### Download the config

```sh
curl -H 'Accept: application/vnd.github.v3.raw'  -O  -L https://raw.githubusercontent.com/dipakvwarade/TelcoCloudPro_b01/main/etcd/core01-ha.config

ls -l core01-ha.config

cat core01-ha.config

```
#### 1. Create a KIND Cluster
If you don't already have a KIND cluster, create one with the following command:
```sh
kind create cluster --config core01-ha.config --name core-ha
```

#### 2. Identify the KIND Node Running ETCD
By default, ETCD runs on the control plane node. List the nodes to find the control plane node:
```sh
kubectl get nodes -o wide
```

#### 3. Access KIND Control Plane Node
To interact with ETCD, you need to get a shell into the control plane container. Find the control plane pod name:
```sh
kubectl get pods -n kube-system -l component=etcd
```

Once you have the pod name, you can exec into it:
```sh
kubectl exec -it etcd-core-ha-control-plane -n kube-system -- sh
```

#### 4. Install etcdctl in the Control Plane Container (if not installed, in our case its already there)
ETCD is typically built into the control plane node’s container, but if `etcdctl` isn't there, you might need to install it. You can download it inside the container or use another method.

#### 5. Configure `etcdctl` to Connect to ETCD
To interact with ETCD, you will need to export the necessary environment variables:
```sh
# ETCD client certificate, key, and CA certificate are found in /etc/kubernetes/pki
etcdctl version
export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/etcd/healthcheck-client.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/etcd/healthcheck-client.key
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379 # explain where to get this address?

### OR you can use following options with command

ETCDCTL_API=3 etcdctl member list \
--cacert="/etc/kubernetes/pki/etcd/ca.crt" \
--cert="/etc/kubernetes/pki/etcd/healthcheck-client.crt" \
--key="/etc/kubernetes/pki/etcd/healthcheck-client.key" --endpoints=127.0.0.1:2379


```


### 6.Lists all members in the etcd cluster
```sh
sh-5.2# etcdctl member list
2f2e1b9c84bfe459, started, core-ha-control-plane2, https://172.19.0.8:2380, https://172.19.0.8:2379, false
63e4b3a007ee9813, started, core-ha-control-plane, https://172.19.0.7:2380, https://172.19.0.7:2379, false
92a3c9b792de5549, started, core-ha-control-plane3, https://172.19.0.6:2380, https://172.19.0.6:2379, false
sh-5.2#
```

### 7. Take etcd backup 
```sh
sh-5.2# ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
> --cacert=/etc/kubernetes/pki/etcd/ca.crt \
> --cert=/etc/kubernetes/pki/etcd/server.crt \
> --key=/etc/kubernetes/pki/etcd/server.key \
> snapshot save etcd-backup.db

{"level":"info","ts":"2024-06-22T02:43:00.19959Z","caller":"snapshot/v3_snapshot.go:65","msg":"created temporary db file","path":"etcd-backup.db.part"}
{"level":"info","ts":"2024-06-22T02:43:00.213564Z","logger":"client","caller":"v3@v3.5.12/maintenance.go:212","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":"2024-06-22T02:43:00.213635Z","caller":"snapshot/v3_snapshot.go:73","msg":"fetching snapshot","endpoint":"https://127.0.0.1:2379"}
{"level":"info","ts":"2024-06-22T02:43:00.472883Z","logger":"client","caller":"v3@v3.5.12/maintenance.go:220","msg":"completed snapshot read; closing"}
{"level":"info","ts":"2024-06-22T02:43:00.518147Z","caller":"snapshot/v3_snapshot.go:88","msg":"fetched snapshot","endpoint":"https://127.0.0.1:2379","size":"24 MB","took":"now"}
{"level":"info","ts":"2024-06-22T02:43:00.520715Z","caller":"snapshot/v3_snapshot.go:97","msg":"saved","path":"etcd-backup.db"}
Snapshot saved at etcd-backup.db
```

### 8. Check backup status

```
sh-5.2# etcdctl snapshot status etcd-backup.db -w table
Deprecated: Use `etcdutl snapshot status` instead.

+----------+----------+------------+------------+
|   HASH   | REVISION | TOTAL KEYS | TOTAL SIZE |
+----------+----------+------------+------------+
| 5dc3b7dd |    91455 |       1276 |      24 MB |
+----------+----------+------------+------------+
```

### 9. Restore backup

to be discussed later


## Further Reading

ETCD uses Raft, its is a consensus algorithm used in Etcd to ensure consistency and durability of data stored in the key-value store. In
Etcd, Raft is used to maintain a distributed log that keeps track of all changes to the cluster state.

Here's how Raft works in Etcd:

1. **Leader Election**: When Etcd starts, each node begins by electing a leader node among themselves using the Leader
Election protocol. The node with the highest term (a unique identifier) wins the election and becomes the leader.
2. **Log Replication**: Once elected, the leader node creates a log of all changes to the cluster state, including new
key-value pairs, updates, and deletes. This log is replicated across all nodes in the cluster using a quorum-based approach.
3. **Term Management**: Each node maintains its own term number, which increments with each change to the log. When a node
becomes aware that it has fallen behind the leader's term, it will reset its term to match the leader's term and start
replicating the log from the leader.
4. **Quorum-based Consensus**: To ensure durability of data, Raft requires a quorum of nodes (usually 2/3 of all nodes) to
agree on a change before it is considered committed. This means that even if some nodes are unavailable or failed, the
majority of nodes can still make progress and maintain consistency.
5. **Follower Node**: Non-leader nodes (followers) periodically send "heartbeat" messages to the leader node to indicate
their availability. If a follower node misses too many heartbeat messages or receives an out-of-date log entry, it will
reset its term and start replicating the log from the leader.
6. **Leader Failure**: When the leader node fails, the followers detect this by missing heartbeat messages. They then elect
a new leader using the Leader Election protocol.

Raft's key benefits in Etcd include:

1. **Consistency**: Raft ensures that all nodes have a consistent view of the cluster state.
2. **Durability**: Even if some nodes fail or are unavailable, the majority of nodes can still maintain consistency and
ensure that data is not lost.
3. **Fault Tolerance**: Raft allows Etcd to continue operating even in the presence of node failures.

Etcd uses a modified version of the Raft algorithm, which includes additional features such as:

1. **Multi-term support**: Etcd supports multiple terms per election, allowing for more efficient leader election and
recovery.
2. **Improved quorum detection**: Etcd uses a quorum-based approach to detect when a majority of nodes are available.
