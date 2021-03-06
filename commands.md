### Authentication
```
# Option 1: use the wrapper script
eval $(authenticate.sh)
# Option 2: insecure
curl -X POST https://hadoop.cesga.es/api/authenticate --data 'username=<USER>&password=<PASSWORD>'
# Option 3: store credentials in a file
# Create a file with the credentials
export LOGIN='username=<USER>&password=<PASSWORD>'
# Load it
. logininfo
curl -X POST https://hadoop.cesga.es/api/authenticate --data $LOGIN

export TOKEN='<TOKEN>'
export AUTH="x-auth-token: $TOKEN"
# curl
curl -H "$AUTH" http://paas:6000/bigdata/api/v1/products
# httpie
http http://paas:6000/bigdata/api/v1/products x-auth-token:$TOKEN
```

### Registering products

```
# Minimal: JSON
http POST http://paas:6000/bigdata/api/v1/products name=reference version=1.0.0 description='Reference product: minimal'
curl -X PUT http://paas:6000/bigdata/api/v1/products/reference/1.0.0/template --data-binary @templates/minimal.json -H "Content-type: application/json"
curl -X PUT http://paas:6000/bigdata/api/v1/products/reference/1.0.0/options --data-binary @options/size.json
curl -X PUT http://paas:6000/bigdata/api/v1/products/reference/1.0.0/orchestrator --data-binary @orchestrators/minimal/fabfile.py
# Minimal: YAML
http POST http://paas:6000/bigdata/api/v1/products name=reference version=1.0.0-yaml description='Reference product: minimal (yaml version)'
curl -X PUT http://paas:6000/bigdata/api/v1/products/reference/1.0.0-yaml/template --data-binary @templates/minimal.yaml -H "Content-type: application/yaml"
curl -X PUT http://paas:6000/bigdata/api/v1/products/reference/1.0.0-yaml/options --data-binary @options/size.json
curl -X PUT http://paas:6000/bigdata/api/v1/products/reference/1.0.0-yaml/orchestrator --data-binary @orchestrators/minimal/fabfile.py
# Get info
http GET http://paas:6000/bigdata/api/v1/products/reference/1.0.0
```

### Launching (instantiating) clusters
```
http POST http://paas:6000/bigdata/api/v1/products/example/0.1.0 size:=1
curl -X POST http://paas:6000/bigdata/api/v1/products/example/0.1.0 -d '{"size": 1}' -H "Content-type: application/json"
# If no options are provided an empty json dict must be provided
curl -X POST http://paas:6000/bigdata/api/v1/products/example/0.1.0 -d '{}' -H "Content-type: application/json"
# To see info about a given cluster
http GET http://paas:6000/bigdata/api/v1/clusters/test/example/0.1.0/1
```
### Destroy cluster
```
http DELETE http://paas:6000/bigdata/api/v1/clusters/test/example/0.1.0/1
```

### Framework
```
# Schedule a cluster instance
curl -X POST -d '{"clusterdn": "instances/test/example/0.1.0/1"}' http://framework:6000/bigdata/mesos_framework/v1/clusters -H 'Content-type: application/json'
# Show the list of queued tasks
curl http://framework:6000/bigdata/mesos_framework/v1/clusters | python -mjson.tool
# Destroy a cluster instance
curl -X DELETE http://framework:6000/bigdata/mesos_framework/v1/clusters/instances--test--example--0__1__0--1
```


