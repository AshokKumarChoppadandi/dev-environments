# Setup & Configuration of Databricks CLI on CentOS 8 Stream

## Prerequisites

* Python3
* Pip3

```
python -V

pip --version
```

<img src="Screenshots/DatabricksCLI/1Python3Pip3Versions.jpg">

## Databricks CLI installation

```
pip install databricks-cli
```

<img src="Screenshots/DatabricksCLI/2DatabricksCLIInstall.jpg">

## Check databricks cli version

```
databricks --version
```

<img src="Screenshots/DatabricksCLI/2DatabricksCLIVersion.jpg">

```
databricks
```

<img src="Screenshots/DatabricksCLI/3DatabricksCLIOptions.jpg">

## Generated Databricks Access Token

1. Go to Azure Databricks home page

<img src="Screenshots/DatabricksCLI/5AzureDatabricksService.jpg">

2. Select the Azure Databricks Service and lick on `Launch Workspace`

<img src="Screenshots/DatabricksCLI/6LaunchAzureDatabricksWorkspace.jpg">

3. After redirecting to Azure Databricks UI, click on the `username` and select the `User Settings` option

<img src="Screenshots/DatabricksCLI/7AzureDatabricksUserSettings.jpg">

4. Under User Settings select option to `Generate a New Token`

<img src="Screenshots/DatabricksCLI/8AzureDatabricksUserSettingsGenerateToken.jpg">

5. Provide the token name and lifetime and click on generate.

<img src="Screenshots/DatabricksCLI/9GenerateToken.jpg">

6. Copy the generated token and save it. This token will not be able to access it later
<img src="Screenshots/DatabricksCLI/10NewToken.jpg">

## Get Azure Databricks URL

<img src="Screenshots/DatabricksCLI/11AzureDatabricksURL.jpg">

## Configuring databricks cli using token

```
databricks configure -h
```

<img src="Screenshots/DatabricksCLI/4DatabricksCLIConfigureOptions.jpg">

```
databricks configure --token
```

<img src="Screenshots/DatabricksCLI/12DatabricksCLIConfigureToken.jpg">

## Validate databricks cli

```
databricks fs ls
```

<img src="Screenshots/DatabricksCLI/13DatabricksCLIValidation.jpg">

```
databricks fs ls dbfs:/databricks-datasets
```

<img src="Screenshots/DatabricksCLI/14DatabricksCLIValidation.jpg">

## Create a Spark Cluster

Create a file `CreateSparkCluster.json` with below content

```
{
    "cluster_name": "TestCluster",
    "spark_version": "12.2.x-scala2.12",
    "node_type_id": "Standard_DS3_v2",
    "spark_conf": {
        "spark.master": "local[*, 4]",
        "spark.databricks.cluster.profile": "singleNode"
    },
    "azure_attributes": {
        "first_on_demand": 1,
        "availability": "ON_DEMAND_AZURE",
        "spot_bid_max_price": -1.0
    },
    "num_workers": 0
}
```

```
cat CreateSparkCluster.json
```

<img src="Screenshots/DatabricksCLI/15CreateSparkClusterJsonFile.jpg">

```
databricks cluster create --json-file CreateSparkCluster.json
```

<img src="Screenshots/DatabricksCLI/16CreateSparkCluster.jpg">

## List the Spark Clusters

```
databricks cluster list
```

<img src="Screenshots/DatabricksCLI/17SparkClusterList.jpg">

## Get Cluster Metadata information

```
databricks clusters get --cluster-id 0602-123524-siuy8fpm
```

<img src="Screenshots/DatabricksCLI/18SparkClusterMetadata.jpg">

```
databricks clusters get --cluster-name 
```

<img src="Screenshots/DatabricksCLI/19SparkClusterMetadataWithName.jpg">

***With this we have the Azure Databricks environment setup ready for writing the Apache Spark Applications using Notebooks***
