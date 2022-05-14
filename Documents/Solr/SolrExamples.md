# Solr Commands

## Configsets API

The Configsets API enables you to upload new configsets to ZooKeeper, create, and delete configsets when Solr is running SolrCloud mode.

Configsets are a collection of configuration files such as solrconfig.xml, synonyms.txt, the schema, language-specific files, DIH-related configuration, and other collection-level configuration files

The API works by passing commands to the configs endpoint. The path to the endpoint varies depending on the API being used: the v1 API uses solr/admin/configs, while the v2 API uses api/cluster/configs. Examples of both types are provided below.

### List Configsets

#### V1 API

```
$ curl --user solr:SolrRocks -X GET http://192.168.0.153:8983/solr/admin/configs?action=LIST
```

#### V2 API

```
$ curl --user solr:SolrRocks -X GET http://192.168.0.153:8983/api/cluster/configs?omitHeader=true
```

### Upload a Configset

Upload a configset, which is sent as a zipped file.

The upload command takes one parameter:

***name*** - The configset to be created when the upload is complete. This parameter is required.

The body of the request should be a zip file that contains the configset. The zip file must be created from within the conf directory (i.e., solrconfig.xml must be the top level entry in the zip file).

***Example:***

```
$ (cd /opt/test-solr/server/solr/configsets/sample_techproducts_configs/conf && sudo zip -r - *) > sample_techproducts_configs.zip

$ curl --user solr:SolrRocks -X POST --header "Content-Type:application/octet-stream" --data-binary @sample_techproducts_configs.zip "http://192.168.0.153:8983/solr/admin/configs?action=UPLOAD&name=techproducts"
```

The same can be achieved using a Unix pipe with a single request as follows:

```
$ (cd server/solr/configsets/sample_techproducts_configs/conf && zip -r - *) | curl --user solr:SolrRocks -X POST --header "Content-Type:application/octet-stream" --data-binary @- "http://192.168.0.153:8983/solr/admin/configs?action=UPLOAD&name=techproducts"
```

The UPLOAD command does not yet have a v2 equivalent API.

### Create a Configset

The create command creates a new configset based on a configset that has been previously uploaded.

The following parameters are supported when creating a configset.

***name*** - The configset to be created. This parameter is required.
***baseConfigSet*** - The name of the configset to copy as a base. This defaults to _default
***configSetProp.property=value*** - A configset property from the base configset to override in the copied configset.

For example, to create a configset named "techproducts_new" based on a previously defined "techproducts" configset, overriding the immutable property to false.

#### V1 API

```
curl --user solr:SolrRocks -X GET http://192.168.0.153:8983/solr/admin/configs?action=CREATE&name=techproducts_new&baseConfigSet=techproducts&wt=xml&omitHeader=true
```

#### V2 API

```
curl --user solr:SolrRocks -X POST -H 'Content-type: application/json' -d '{ 
  "create":{
    "name": "test2",
    "baseConfigSet": "_default"}}' \
    http://192.168.0.153:8983/api/cluster/configs?omitHeader=true
```

### Delete a Configset

The delete command removes a configset. It does not remove any collections that were created with the configset.

***name*** -The configset to be deleted. This parameter is required.

To delete a configset named "myConfigSet":

#### V1 API

```
curl --user solr:SolrRocks -X GET http://192.168.0.153:8983/solr/admin/configs?action=DELETE&name=techproducts_new&omitHeader=true
```

#### V2 API

```
curl --user solr:SolrRocks -X DELETE http://192.168.0.153:8983/api/cluster/configs/techproducts_new?omitHeader=true
```

## create_collection

Syntax:

```
solr create -c <CollectionName> -d <configDir> -n <configName> -shards <numOfShards> -replicationFactor <numOfReplicas> -p <portNumber>
```

Example:

```
solr create -c Test1 -d /solr/configs/techproducts -n techproducts -shards 2 -replicationFactor 2 -p 8983
```

## Excercises

1. Start Solr, Create Collection, index some documents & perform searches

2. Works with different set of data, and explores requesting facets with a dataset.

3. Work with our own data and start a plan for your implementation

4. Spatial Search and getting Solr instance back into a clean state