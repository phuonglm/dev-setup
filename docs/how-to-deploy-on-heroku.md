# How to deploy on Heroku

Follow these steps to deploy apps to Heroku.

## Automatically with CI

- Create a Heroku app and take note of its name.

- Set the following variables for the CI system to deploy on staging:

  + HEROKU_APP_NAME_STAGING with value of your created Heroku app name
  + HEROKU_API_KEY_STAGING with the value of API Key from https://dashboard.heroku.com/account

- - Set the following variables for the CI system to deploy on production:

  + HEROKU_APP_NAME_PROD with value of your created Heroku app name
  + HEROKU_API_KEY_PROD with the value of API Key from https://dashboard.heroku.com/account


- After CI deployment succeeded, use heroku client on your project,
  `$ heroku git:remote -a <heroku-app-name>` and then:

  ```bash
  $ heroku config # to see the list of config vars
  $ heroku ps:scale web=1 # to start the web
  ```

- Configure the Heroku app environment variables if any

- After that, open the Heroku app, it should work


## Or Manually with Heroku Docker

Make sure to have Docker running on your machine.

https://devcenter.heroku.com/articles/container-registry-and-runtime

- Login to Heroku registry:

```bash
$ heroku container:login
```

- Deploy with existing Docker image

```bash
$ docker pull <image>
$ docker tag <image> registry.heroku.com/<heroku_app_name>/web
$ docker push registry.heroku.com/<heroku_app_name>/web
```

For example, to deploy `registry.gitlab.com/hoatle/nextjs-hello-world:develop` to `acme-nextjs-hoatle` Heroku app:

```bash
$ docker pull registry.gitlab.com/hoatle/nextjs-hello-world:develop
$ docker tag registry.gitlab.com/hoatle/nextjs-hello-world:develop registry.heroku.com/acme-nextjs-hoatle/web
$ docker push registry.heroku.com/acme-nextjs-hoatle/web
```

## References

- https://devcenter.heroku.com/articles/container-registry-and-runtime
