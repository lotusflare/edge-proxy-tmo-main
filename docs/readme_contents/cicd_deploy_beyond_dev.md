# Extending Past Dev

Out-of-the-box, the included CICD pipeline only deploys to your `Dev` environment.

We provided commented-out sections in the pipeline to provide a skeletal structure on how to
deploy to other standard environments.

## Understanding the Stages

[GitLab Pipelines](https://docs.gitlab.com/ee/ci/pipelines/) are two main pieces:
1. Jobs: Which are discrete units of work (e.g.: compiling your code, running static code analysis)
2. Stages: Which are groupings of one or more Jobs. Stages are executed in the order specified <br/>
by the `stages` section of the piepline file (`.gitlab-ci.yml`)

With the out-of-the-box CICD pipeline, the stages section looks like below:

The stages are not visible in the provided `.gitlab-ci.yml` but the included `.tmo.function.edge.helm-deploy.gitlab-ci.yml` has them defined.

```
stages:
  - tmo
  - test
  - build

npe_dev_deploy:
  extends: .install_helm
  variables:
    EDGE_VALUES: "./config/dev_values.yaml"

```

### **Build**

This stage builds and deploys your configuration to ADN Edge Gateway. We use the [Edge Helm Deployment job](https://gitlab.com/tmobile/templates/-/blob/edgegateway/dev01/gitlab-ci/.tmo.function.edge.helm-deploy.gitlab-ci.yml)
to ensure consistency in how T-Mobile deploys configuration to ADN Edge Gateway.

The `.install_helm` which is configured in the `Edge Helm Deployment job` above is referred in the project
deployment job

#### Understanding Per-Environment Variables

We can re-use the stages by tailoring the
environment specific stage in the `.gitlab-ci.yml`.

If the out-of-the-box CICD pipeline, the `Dev` environment variables are
pre-populated based on your selections when you ran the Starter Kit. For example,
it may look something like this:

```

npe_dev_deploy:
  extends: .install_helm
  variables:
    EDGE_VALUES: "./config/dev_values.yaml"

```

As you see below, we will reference this section of the pipeline file via
an `extends` statement to pull these variables in, thus allowing us to change behavior on a per-environment basis

```

include:
  - project: "tmobile/templates"
    ref: edgegateway/dev01
    file: "/gitlab-ci/.tmo.function.edge.helm-deploy.gitlab-ci.yml"

variables:
  SLACK_WEBHOOK: "https://t-mo.slack.com/services/hooks/jenkins-ci/SToaaMPFiXAJyXKW3d9C0ZNG"

npe_dev_deploy:
  extends: .install_helm
  variables:
    EDGE_VALUES: "./config/dev_values.yaml"

#npe_test_deploy:
#  extends: .install_helm
#  when: manual
#  variables:
#    EDGE_VALUES: "./config/test_values.yaml"

#prod_deploy:
#  extends: .install_helm
#  when: manual
#  variables:
#    EDGE_VALUES: "./config/prod_values.yaml"

```

#### Understanding the significance of vairables to customize to your application needs

### EDGE_VALUES

The `{env}_values.yaml` inside the provided config directory which contains cors policy, routes, target servers which host the backend service and weighted percentage of traffic to each of them. These can be modfied to fit to your application needs. Detailed information on important structures is provided below to customize your configuration to be deployed to ADN Edge Gateway.

####  envName

The valid value is typically one of "dev", "dev01", "dit01", "test", "qlab01", "qlab02", "qlab03", "qlab06", "qlab07", "plab", "prd", "stg" defined for your domain. It tells the deployment about the name of the environment for which configuration being applied, in a way provides transparency to the API consumers by providing ADN Edge Gateway endpoint having this info.

```
envName: 'dev'
```

###  deployToPlatforms

The valid values are `Internal` and/or `External`. These values are used to deploy the configuration for your backend service either on internal or external ADN Edge Gateway or on both. In the below configuration, we are generating configuration only to be deployed on internal ADN Edge Gateway.

```
deployToPlatforms: ["internal"]

```

###  headerManipulation

The `headerManipulation` section lists out any manipulations that need to be done on the headers in the request or response.

1. The `requestHeadersToAdd` specifies any request headers to be added for system operational metrics or for the target service as part of any processing instructions.
2. The `responseHeadersToRemove` specifies any response headers to be removed before sending the response to the client.
3. The `responseHeadersToAdd` specifies any response headers to be added before sending the response to the client.


This configuration can be overridden if you choose to, in the `routes` section by adding the corsPolicy in the `matchers` section under `routes`.

```
headerManipulation:
  requestHeadersToAdd:
    - key: "base-path"
      value: "/ifm/v1-GET"
    - key: "operation-path"
      value: "/msisdn/identity-POST"
  responseHeadersToRemove:
    - key: x-envoy-upstream-service-time
  responseHeadersToAdd:
    - key: "response-header-1"
      value: "response-value-1"
```


### corsPolicy

The `corsPolicy` section lists out the corsPolicy that can be applied for all the routes. This configuration can be overridden if you choose to, in the `routes` section by adding the corsPolicy in the routes section.

1. The `allowOrigin` specifies the origins that will be allowed to make CORS requests. An origin is allowed if either allow_origin or allow_origin_regex match.
2. The `allowOriginRegex` specifies regex patterns that match origins that will be allowed to make CORS requests. An origin is allowed if either allow_origin or allow_origin_regex match.
3. The `allowMethods` specifies the content for the access-control-allow-methods header.
4. The `allowHeaders` specifies the content for the access-control-allow-headers header.
5. The `exposeHeaders` specifies the content for the access-control-expose-headers header.
6. The `maxAge` specifies the content for the access-control-max-age header.
7. The `allowCredentials` specifies whether the resource allows credentials.

```
corsPolicy:
  allowOrigin:
    - "www.t-mobile.com"
  allowOriginRegex:
    - "[a-zA-Z0-9]*.t-mobile.com"
  allowMethods:
    - GET
    - POST
  allowHeaders:
    - origin
  exposeHeaders:
    - origin
  maxAge: 1d
  allowCredentials: true

```

### routeAction
The `routeAction` section lists out the common configuration that needs to be applied to all matching URI paths at the routes level. This configuration can be overridden if you choose to, in the `routes` section which is explained in detail in the following section.

The `targets` defines how you want to split the traffic in the case where you have service deployed on multiple servers. The actual mapping of the target name to the actual host is defined and explained in the `edgeTargets` section.

For example, below we defined `routeAction` configuration to be applied to all the matching paths in the `routes` section. We are essentially saying the traffic is to be routed evenly between the target servers where the service is deployed.

```
routeAction:
  targets:
    - name: test-proxy-target-1
      weight: 50
    - name: test-proxy-target-2
      weight: 50
```

### routesConfig
The `routesConfig` section lists out the configuration that needs to be applied to matching URI paths defined in `routes` section. If you choose to, you can override the common configuration at `matchers` level. In the below example, we overrode the `corsPolicy` in one `matchers` section and `routeAction` in another.

```
routesConfig:
  routes:
  - matchers:
      path:
        value: "^/api/v3/pet/[^/]*/uploadImage"
        matchType: "regex"
      httpMethods: ["POST"]
      routeDescriptor: "/api/v3/pet/{petId}/uploadImage-POST"
      corsPolicy:
        allowOrigin:
          - "www.t-mobile.com"
        allowOriginRegex:
          - "[a-zA-Z0-9]*.t-mobile.com"
        allowMethods:
          - GET
          - POST
          - OPTIONS
        allowHeaders:
          - origin
        exposeHeaders:
          - origin
        maxAge: 1d
        allowCredentials: true
  - matchers:
      path:
        value: "/api/v3/store/inventory"
        matchType: "prefix"
      httpMethods: ["GET"]
      routeDescriptor: "/api/v3/store/inventory-GET"
      routeAction:
        targets:
          - name: test-proxy-target-1
            weight: 70
          - name: test-proxy-target-2
            weight: 30
```


### routes

The `routes` section shows how to match the incoming request path to the backend service and what percent of traffic needs to be routed incase of service deployed on multiple servers.


**_path_**
1. The `value` which tells how you want to match the incoming request to map to the backend service. Please pay special attention to make sure the path matching should be one to one mapping to have a clear cut obeservability and not to overlap with other paths
2. The `matchType` is how you want to match the incoming request to the defined property in the '`value` field

The `headers` defines all the header names & respective values to be validated before the request is forwarded to the target service

The `queryParams` defines all the query parameters & respective values to be validated before the request is forwarded to the target service

The `httpMethods` defines what is the defined operation type for the end point defined in the swagger spec for the backend service

The `routeDescriptor` is basically the actual path & the operation type defined in the swagger spec for the backend service. This  is for observability and metrics standpoint on the ADN Edge Gateway for the configured service.

**_prefixRewrite_**
<br>The `prefixRewrite` is an optional field that can be used to replace the matched request path with the specified value. For example in the below routes section the path that matches to the `/selfservice-dev/v1`
will be replaced with `/dev1/api` when forwarded to the upstream service.


```
routes:
  - matchers:
      path:
        value: "^/api/v3/pet/[^/]*/uploadImage"
        matchType: "regex"
      httpMethods: ["POST"]
      routeDescriptor: "/api/v3/pet/{petId}/uploadImage-POST"
      corsPolicy:
        allowOrigin:
          - "www.t-mobile.com"
        allowOriginRegex:
          - "[a-zA-Z0-9]*.t-mobile.com"
        allowMethods:
          - GET
          - POST
          - OPTIONS
        allowHeaders:
          - origin
        exposeHeaders:
          - origin
        maxAge: 1d
        allowCredentials: true
  - matchers:
      path:
        value: "/api/v3/store/inventory"
        matchType: "prefix"
      httpMethods: ["GET"]
      routeDescriptor: "/api/v3/store/inventory-GET"
      routeAction:
        targets:
          - name: test-proxy-target-1
            weight: 70
          - name: test-proxy-target-2
            weight: 30
  - matchers:
      path:
        value: "/selfservice-dev/v1"
        matchType: "prefix"
      httpMethods: ["GET"]
      routeDescriptor: "/selfservice-dev/v1"
      prefixRewrite: "/dev1/api"
      headerManipulation:
        requestHeadersToAdd:
          - key: "base-path"
            value: "/ifmtest/v1"
          - key: "operation-path"
            value: "/msisdntest/identity"
        responseHeadersToRemove:
          - key: x-envoy-upstream-service-time
        responseHeadersToAdd:
          - key: "response-header-1"
            value: "response-value-1"
  - matchers:
      path:
        value: "^/api/v3/store/order/[^/]*$"
        matchType: "regex"
      headers:
        - name: header1
          value: value1
          matchType: "regex"
        - name: header2
          value: value1
        - name: header3
          value: value1
        - name: header4
          matchType: "invert"
      queryParams:
        - name: param1
          value: value1
          matchType: "regex"
        - name: param2
          value: value2
      httpMethods: ["GET"]
      routeDescriptor: "/api/v3/store/order/{orderId}-GET"
```


### edgeTargets
This section defines the list of mappings of the target name defined in routeAction to the actual host and port along with the health check endpoint for the service.

```
edgeTargets:
  - name: test-proxy-target-1
    hosts:
      - addr: ifm-dev.px-npe20.mesh.t-mobile.com
        port: 443
    healthcheck:
      path:  /actuator/health
  - name: test-proxy-target-2
    hosts:
      - addr: ifm-dev.px-npe50.mesh.t-mobile.com
        port: 443
    healthcheck:
      path:  /actuator/health
```

