# Prerequisites
- Install a kubernetes environment (I recommend [k3d](https://k3d.io/v5.3.0/))
- AWS account
- AWS S3 bucket
- Modify install_secrets.sh file to configure AWS credentials to store backup files in a bucket
```
...
kubectl create secret generic aws-creds \
  --from-literal=ACCESS_KEY_ID=<access_key_id> \
  --from-literal=ACCESS_SECRET_KEY=<access_secret_key>
...
```

# Description
This scripts will give you the availability to do a CNP (Cloud Native Postgres) demo in a kubernetes environment.
If you have any problem, don't hesitate to contact me: sergio.romera@enterprisedb.com

# Use case 1: Create cluster 1 and cluster 2 from S3 backups
![](./images/usecase1.png)

# Test1 - DR: Create cluster2 from cluster1 from S3 backup
- Create cluster1
```
install_cnp.sh
```
- Backup cluster1
```
kubectl apply -f backup_cluster1.yaml
```
- Create cluster2
```
kubectl -f cluster2.yaml
```

# Use case 2: DR from cluster1 using wal streaming replication 
![](./images/usecase2.png)

# Test2 - DR from cluster1 using wal streaming replication
- Create cluster1
```
install_cnp.sh
```
- Backup cluster1
```
kubectl apply -f backup_cluster1.yaml
```
- Create cluster2
```
kubectl -f cluster2_wal_streaming.yaml
```

# Test2 - Promote cluster2 (DR from cluster1)
- Be sure that all transactions are replicated (check LSN in cluster1 and cluster2)
- Apply file cluster2 wal streaming with backup
```
kubectl apply -f cluster2_wal_streaming_backup.yaml
```
- Verify that cluster2 has a primary node
- Execute a backup from cluster2
```
kubectl apply -f backup_cluster2.yaml
```

# Test2 - Rollback to cluster1
- Delete cluster1
```
kubectl delete -f cluster1.yaml
```
- Create cluster1 from cluster2
```
kubectl apply -f cluster1_wal_streamin_restore.yaml
```
- Verify that cluster1 is working well 
```
kubectl cnp status cluster1
```

# Commands
```
select pg_switch_wal();
select pg_current_wal_lsn();
select current_user;
k exec -it cluster1-1 -- psql
k exec -it cluster2-1 -- psql

# Port Forwarding
kubectl port-forward cluster1-1 5432:5432
kubectl port-forward service/cluster1-rw 5454:5432
```
