#!/usr/bin/env bash
# This script sets the target address based upon app and env

setTosTarget() {
   CLUSTER=dd-stg.kube.t-mobile.com
   if [[ $DEPLOY_ENVIRONMENT == qlab0* ]]; then
      ENV_PREFIX=${DEPLOY_ENVIRONMENT//qlab0/ql}
   elif [[ $DEPLOY_ENVIRONMENT == test ]]; then
      ENV_PREFIX=qat
   elif [[ $DEPLOY_ENVIRONMENT == dev01 ]]; then
      ENV_PREFIX=dev
   elif [[ $DEPLOY_ENVIRONMENT == plab ]]; then
      ENV_PREFIX=plb
   elif [[ $DEPLOY_ENVIRONMENT == plab01 ]]; then
      ENV_PREFIX=pl1
   elif [[ $DEPLOY_ENVIRONMENT == stg0* ]]; then
      ENV_PREFIX=${DEPLOY_ENVIRONMENT//stg0/qa}
   elif [[ $DEPLOY_ENVIRONMENT == stg ]]; then
      ENV_PREFIX=stg
   elif [[ $DEPLOY_ENVIRONMENT == prd ]]; then
      CLUSTER=dd-prd.kube.t-mobile.com
      ENV_PREFIX=prd
   elif [[ $DEPLOY_ENVIRONMENT == prd01 ]]; then
      CLUSTER=dd-prd.kube.t-mobile.com
      ENV_PREFIX=prd-offline
   fi
   TARGET_ADDR=tos-$APP_NAME-$ENV_PREFIX.$CLUSTER
}

setMyTmoTarget() {
   CLUSTER=dd-stg.kube.t-mobile.com
   if [[ $DEPLOY_ENVIRONMENT == qlab01 ]]; then
      ENV_PREFIX=dev20-dev
   elif [[ $DEPLOY_ENVIRONMENT == qlab02 ]]; then
      ENV_PREFIX=e2-stg
   elif [[ $DEPLOY_ENVIRONMENT == qlab03 ]]; then
      ENV_PREFIX=e4-stg
   elif [[ $DEPLOY_ENVIRONMENT == qlab06 ]]; then
      ENV_PREFIX=reg5-reg
   elif [[ $DEPLOY_ENVIRONMENT == qlab07 ]]; then
      ENV_PREFIX=reg6-reg
   elif [[ $DEPLOY_ENVIRONMENT == plab ]]; then
      ENV_PREFIX=reg3-reg
   elif [[ $DEPLOY_ENVIRONMENT == plab01 ]]; then
      ENV_PREFIX=sitma-plb
   elif [[ $DEPLOY_ENVIRONMENT == stg01 ]]; then
      ENV_PREFIX=e1-stg
   elif [[ $DEPLOY_ENVIRONMENT == stg02 ]]; then
      ENV_PREFIX=e9-stg
   elif [[ $DEPLOY_ENVIRONMENT == stg03 ]]; then
      ENV_PREFIX=reg9-reg
   elif [[ $DEPLOY_ENVIRONMENT == stg04 ]]; then
      ENV_PREFIX=e8-stg
   elif [[ $DEPLOY_ENVIRONMENT == stg05 ]]; then
      ENV_PREFIX=e5-stg
   elif [[ $DEPLOY_ENVIRONMENT == stg ]]; then
      ENV_PREFIX=e3-stg
   elif [[ $DEPLOY_ENVIRONMENT == prd ]]; then
      CLUSTER=dd-prd.kube.t-mobile.com
      ENV_PREFIX=prd-a-prd
   elif [[ $DEPLOY_ENVIRONMENT == prd01 ]]; then
      CLUSTER=dd-prd.kube.t-mobile.com
      ENV_PREFIX=prd-b-prd
   fi
   TARGET_ADDR=mtm-$ENV_PREFIX.$CLUSTER
}

setStorelocatorTarget() {
   if [[ $DEPLOY_ENVIRONMENT == stg ]]; then
      TARGET_ADDR=1tnru1no7e.execute-api.us-west-2.amazonaws.com
   elif [[ $DEPLOY_ENVIRONMENT == prd ]]; then
      TARGET_ADDR=onmyj41p3c.execute-api.us-west-2.amazonaws.com
   elif [[ $DEPLOY_ENVIRONMENT == prd01 ]]; then
      TARGET_ADDR=onmyj41p3c.execute-api.us-west-2.amazonaws.com
   else
      TARGET_ADDR=kkcdrrnxwk.execute-api.us-west-2.amazonaws.com
   fi
}

if [[ "${APP_NAME}" == 'mytmo' ]]; then
  setMyTmoTarget
elif [[ "${APP_NAME}" == 'storelocator' ]]; then
  setStorelocatorTarget
else
   setTosTarget
fi
echo $TARGET_ADDR
