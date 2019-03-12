This challenge is a part of Unbabel challenge for SRE (Site Reliability Engineer).

## Description

This challenge is divided into 2 non-sequential parts, ***Planning*** and ***Execution***.

Both parts will include detailed instructions on what to do and how to do it.


### Context

We're building ***MultiVAC***, a multi-purpose, self-adjusting and self-correcting computer that will help us understand how to reverse the universe's entropy.

Of course, we're at the very early stages, and as such, we're starting with the bare minimum. Our MultiVAC is currently in the form of a single application that uses a ***web api*** through ***http*** with a limited number of ***endpoints***.

There are several actions MultiVAC can perform, and answer only one question.

```
Question:
* How can the entropy of the universe be reveserd?
```

```
Actions:
* Acquire more data.
* Process data.
```

***App Architecture***

```
* Flask Server
* Worker Machines
* Redis Server
* MongoDB
```

***Endpoint mapping***

1) Question

```
GET /multivac
```

2) Acquire more data

```
POST /multivac/data
```

Body parameters (form):
```
data: String
```

3) Acquire zzz data
```
GET /zzz
```

### Testing MultiVAC

To run MultiVAC do:

```

python manage.py runserver
python manage.py worker


```

Multivac needs to learn until it provides a meaningful answer to our question.

To test it do as follows:

* Invoke the ``` GET /multivac``` endpoint and check if MultiVAC is able to answer
* If MultiVAC is not giving you a proper answer, you need to feed it with more data and make it process it.
* To feed data into MultiVAC invoke ```POST /multivac/data``` and pass data to answer the question.
* While MultiVAC processes data asynchronously, try to keep questioning it a couple of times to see if it can answer back. If not, repeat the whole process and feed more data into it.


## Planning

The architecture is presented in a [HLD](docs/HLD.png) and will run on a kubernetes cluster running on Google Cloud Platform.


This architecture is focused mainly on:
	-	Scalability;
	-	Security;
	-	And most importantly to change as little of the program as possible.


### Detailed planning
The presented solution contains:
	-	MongoDB as database tier;
	-	Redis cluster job parallelization;
	-	MultiVAC as a backend application;
	-	Nginx http server as frontend for the services running on kubernetes.



This solution makes use of an http server as reverse proxy in order to prevent the rest of the services to be directly exposed to the internet.
Also relieves the developers of duties such as integrating https and authentication in their application and manage certificates for each application (but doesn't make an obstacle if they want to do so).


To put it simple, this solution makes it easier to:
	-	Keep track of requests and logs them, even if the backend applications crash;
	-	Apply security practises such as https and authentication without enforcing them on the backend applications;
	-	Monitor or even prevent bursts of requests on the frontends without disrupting backend applications;
	-	Scale the frontends fast since they are faster to spawn.



## Execution

In order to execute the solution, a cluster in Google Cloud Platform was created.
The execution was divided into 3 parts:
	-	A Basic solution in a "just works" fashion, running the MultiVAC exposed to the internet complying of the 2 main functions (get data and put data) as well as monitoring (through StackDriver) and logging (through GCP integrated logging);
	-	A Hardened solution which included nginx reverse proxy as frontends as well as https and http basic authentication in some endpoints.

### 2.1 Deployment
In order to make it easier to deploy a [helper-script](helper-scripts/helper.sh) was created. This script makes it easier to deploy the cluster (but is not as near as resilient as it should be).

### 2.2 Continous Integration
For CI/CD GitLab AutoDevOps was used.

### Technologies used
List of  technologies used:
	-	Nginx for frontend and proxy;
	-	Redis cluster for parallel jobs;
	-	MongoDB for NoSQL database;
	-	Python (with flask);
	-	Docker for containers;
	-	Kubernetes for orchestration;
	-	StackDriver for monitorization and alarms;
	-	Google integrated logging for logging.

## Possible improvements
*	Use of a CI/CD independent of the backing platform used, such as Jenkins;
*	Improve CI/CD pipeline;
*	Improve automation scripts using a technology such as [Helm](https://helm.sh/)


## Final regards
I really loved doing the challenge!
