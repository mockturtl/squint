example
=======

### [postman_collection.json][]

Import to [Postman][] REST client.

###### setup

Your <img src="assets/eye.png" alt="eye" title="Postman environment" width="16px"/> [Postman environment][] must define secrets to provide the GitHub API:

- `:owner`
- `:repo`
- `:name`
- `OAUTH-TOKEN`

[postman environment]: https://www.getpostman.com/docs/environments
[postman]: http://www.getpostman.com/
[postman_collection.json]: postman_collection.json

### [example.dart][]

```sh
$ dart example.dart
```

###### setup

Your [environment][] must define certain variables to provide the GitHub API.

```bash
$ source .env
```

[example.dart]: example.dart
[environment]: https://github.com/mockturtl/squint/blob/master/.env.example
