
# CICD Pipeline Details

This page details how the included CICD pipeline works.


## Required ADN Edge Gateway CI/CD Variables

While the CICD pipeline sets many of the ADN Edge Gateway-related variables for your `Dev` environment for you, it is important to understand these variables, their purpose, and how to set them for other environments. Let's start by spelling out the required variables to deploy your proxy to ADN Edge Gateway Edge Gateway.

`svc_dev_apicoe` account is dafulted in the scripts and the password for this account needs to be configured as a CI/CD variable in the subgroup where you want to create a project.

| ADN Edge Gateway CI/CD Variable Name | Description                          | Example                                                             |
|--------------------------------|--------------------------------------|---------------------------------------------------------------------|
| K8S_PASS              | The base64 encoded Password   |  |
| K8S_PASS_BASE64                       | Flag to mention if password is base64 encoded or not            | true/false                                                    |

We will talk about these variables more in the "Understanding Per-Environment Variables" section later.

### Side Note: K8S_PASS

In many cases - and almost always for Service Accounts - passwords will have special characters in them. In order to ensure these passwords can be passed to ADN Edge Gateway correctly, we should encode them as a [Base64](https://en.wikipedia.org/wiki/Base64) string.

On Windows:
1. Put your password into a file (we will use `raw.txt` for this example)
2. Run: `certutil -f -encode raw.txt encoded.txt`
3. Your encoded password will be in the file `encoded.txt` (Note: This will overwrite any prior contents of that file)

On Mac:
1. Run `echo 'your_password' | base64`
2. Your password will be printed to the CLI

**IMPORTANT**: __Never__ put any passwords in your `.gitlab-ci.yml`... EVER!! These should be stored as CICD variables under `Settings -> CICD -> Variables`.

### K8S_PASS_BASE64

Since the password is always base64 encoded becasue of the presence of special characters, the flag should always be "true"
