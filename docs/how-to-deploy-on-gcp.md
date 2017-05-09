# How to deploy apps on Google Cloud Platform (GCP)

## Google App Engine (GAE)

- Use `gcloud` sdk
- Create the app with `$ gcloud app create`
- Deploy the app with: `$ gcloud app deploy --image-url=$GCP_IMAGE`


## Auto deployment with CI system

- Set the following variables for staging deployment (develop branch):

  + GCP_IMAGE_STAGING
  + GCP_KEY_FILE_STAGING
  + GCP_PROJECT_ID_STAGING

- Set the following variables for production (live) deployment (master branch):

  + GCP_IMAGE_PROD
  + GCP_KEY_FILE_PROD
  + GCP_PROJECT_ID_PROD

- The `GCP_KEY_FILE_STAGING` or `GCP_KEY_FILE_PROD` content should be created from the guide:
  https://medium.com/evenbit/an-easy-guide-to-automatically-deploy-your-google-app-engine-project-with-gitlab-ci-48cb84757125

- Don't forget to enable `Google App Engine Admin APIs` and `$ gcloud app create` first


## Google Container Engine (GKE)

- Use `kubectl` client
- Use `Helm`
- Deploy app with: `$ helm install helm-charts/<application>`

## Auto deployment with CI system

- Set the following variables for staging deployment (develop branch):

  + GCP_KEY_FILE_STAGING
  + GCP_PROJECT_ID_STAGING
  + GCP_CLUSTER_NAME_STAGING
  + GCP_ZONE_STAGING
  + GCP_APP_NAME_STAGING

  And fill in more environment variables required per projects (usually under .env.dev file for reference)

- Set the following variables for production (live) deployment (master branch):

  + GCP_KEY_FILE_PROD
  + GCP_PROJECT_ID_PROD
  + GCP_CLUSTER_NAME_PROD
  + GCP_ZONE_PROD
  + GCP_APP_NAME_PROD

  And fill in more environment variables required per projects (usually under .env.dev file for reference)

- The `GCP_KEY_FILE_STAGING` or `GCP_KEY_FILE_PROD` content should be created from the guide:
  https://medium.com/evenbit/an-easy-guide-to-automatically-deploy-your-google-app-engine-project-with-gitlab-ci-48cb84757125


- Don't forget to create the K8s cluster first on GKE.


## Learn more

- https://cloud.google.com/appengine/
- https://cloud.google.com/container-engine/
