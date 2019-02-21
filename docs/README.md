# Docs
After problem analysis, three solutions were devised each of which adds new functionality to the cluster.

## Basic Solution
In this solution just the basics should work, i.e. the MultiVAC system "just works".


The proposed architecture is:
	-	1 MultiVAC pod with ServiceType LoadBalancer and service port redirect (tcp/80 -> tcp/5000);
	-	1 Redis pod with ServiceType ClusterIP (default) and 1 PVC in ReadWriteOnce access mode;
	-	1 worker pod with ServiceType ClusterIP (default);
	-	1 Mongo pod with ServiceType ClusterIP (default) and 1 PVC in ReadWriteOnce access mode.



