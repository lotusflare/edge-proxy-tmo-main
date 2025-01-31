# Starter Kit Details

This Starter Kit supports both a "Create Application" mode, as well as a "Hello World" mode. You can [learn more about these modes here](https://developer-toolbox.docs.t-mobile.com/docs/end-user/starter_kits/#choosing-a-path), but the main difference is that "Hello World" is a more streamlined version of the "Create Application" mode, but with many defaults pre-set to simplify deployment and facilitate learning.

## How the Starter Kit Works

This Starter Kit provides a "batteries included" code repository, complete with:
* GitLab pipeline that deploys your proxy to ADN Edge Gateway
* Auto generated values.yaml file which contains the `Configuration` for the ADN Edge Gateway

The end result is a ready-to-code project that allows you to focus on creating configuration for your backend service.

## Generator Source Code

If you are interested in how the Generator works - or want to contribute to its code - you can [find it here](https://gitlab.com/tmobile/ace/edge-gateway/apps/edge-gw-proxy-gen-ms).

## CICD Pipeline

There is a fully-functional, end-to-end CICD pipeline included with this repo that automatically deploys to your `Dev` environment. The sections below elaborate on how it works, how to change the configuration, and how to deploy beyond `Dev`.

### CICD Pipeline Basics 

If you want to learn how to customize the CICD pipeline, check out the [documentation in the `/docs`](./docs/readme_contents/cicd_configuration.md) directory.

### Deploying Beyond Dev 

To deploy to environments beyond `Dev`, refer to the [documentation here detailing that process](./docs/readme_contents/cicd_deploy_beyond_dev.md).

### Environment Name To Environment Type Mapping

**Environment Name**|**Environment Type**
:-----:|:-----:
dev|npe
dev01|npe
dit01|npe
test|npe
qlab01|npe
qlab02|npe
qlab03|npe
qlab06|npe
qlab07|npe
plab|npe
prd|prd
stg|prd


### Proxy Endpoints
After the pipeline ran successfully, below are the endpoints to check for successful deployment of your service. You can find the `proxy-name` & `env-name` in the values.yaml.


#### For TKE Non-Prod:

##### Internal ADN Edge Gateway Routes:

`https://{proxy-name}-{env-name}.geo-npe.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-dev.geo-npe.mesh.t-mobile.com/actuator/health`

##### External ADN Edge Gateway Routes:

`https://{proxy-name}-{env-name}.geo-npe.ext.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-dev.geo-npe.ext.mesh.t-mobile.com/actuator/health`

#### For Conducktor Non-Prod:

##### Internal ADN Edge Gateway Routes:

`https://{proxy-name}-{env-name}.npe-edge.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-dev.npe-edge.kube.t-mobile.com/actuator/health`

##### External ADN Edge Gateway Routes:

`https://{proxy-name}-{env-name}.npe-edge.ext.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-dev.npe-edge.ext.kube.t-mobile.com/actuator/health`

#### For TKE Prod:

##### Internal ADN Edge Gateway Routes:

###### Geo Location Based Route:

`https://{proxy-name}-{env-name}.geo.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.geo.mesh.t-mobile.com/actuator/health`

###### Polaris DC Route:

`https://{proxy-name}-{env-name}.px.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.px.mesh.t-mobile.com/actuator/health`

###### Titan DC Route:

`https://{proxy-name}-{env-name}.tt.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.tt.mesh.t-mobile.com/actuator/health`

##### External ADN Edge Gateway Routes:

###### Geo Location Based Route:

`https://{proxy-name}-{env-name}.geo.ext.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.geo.ext.mesh.t-mobile.com/actuator/health`

###### Polaris/Titan DC Route:

`https://{proxy-name}-{env-name}.px.ext.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.px.ext.mesh.t-mobile.com/actuator/health`

###### Titan DC Route:

`https://{proxy-name}-{env-name}.tt.ext.mesh.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.tt.ext.mesh.t-mobile.com/actuator/health`

#### For Conducktor Prod:

##### Internal ADN Edge Gateway Routes:

###### Geo Location Based Route:

`https://{proxy-name}-{env-name}.prd-edge.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-dev.prd-edge.kube.t-mobile.com/actuator/health`

###### West Region Route:

`https://{proxy-name}-{env-name}.west.prd-edge.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.west.prd-edge.kube.t-mobile.com/actuator/health`

###### East Region Route:

`https://{proxy-name}-{env-name}.east.prd-edge.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.east.prd-edge.kube.t-mobile.com/actuator/health`

##### External ADN Edge Gateway Routes:

###### Geo Location Based Route:

`https://{proxy-name}-{env-name}.prd-edge.ext.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-dev.prd-edge.ext.kube.t-mobile.com/actuator/health`

###### West Region Route:

`https://{proxy-name}-{env-name}.west.prd-edge.ext.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.west.prd-edge.ext.kube.t-mobile.com/actuator/health`

###### East Region Route:

`https://{proxy-name}-{env-name}.east.prd-edge.ext.kube.t-mobile.com/actuator/health`

Example:

`https://test-proxy-prd.east.prd-edge.ext.kube.t-mobile.com/actuator/health`
