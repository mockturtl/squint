squint
======

Squint is a client for GitHub's [issue labels][] api (v3).

Groom the default tags to suit your team.

Try it with [Stagehand][] in a new repo.

[![Stories in Ready](https://badge.waffle.io/mockturtl/squint.png?label=ready&title=Ready)](http://waffle.io/mockturtl/squint)

[stagehand]: http://stagehand.pub/

###### setup

Create [`.env`][.env] from the template file and fill in its values.

usage
-----

Create [`.squintrc.json`][squintrc] with the issue labels you wish to add, remove, or change.

```json
{ "remove":
  [ "help wanted"
  , "invalid"
  , "question"
  , "enhancement"
  ]
, "add": 
  [ { "name": "blocked", "color": "800000" }
  , { "name": "ready", "color": "01ff70" }
  , { "name": "android", "color": "a4c639" }
  , { "name": "jigglypuff", "color": "fad0de" }
  ]
, "change":
  [ { "name": "bug", "color": "d32f2f" }
  , { "name": "wontfix", "color": "000000" }
  , { "name": "duplicate", "color": "333333" }
  ]
}
```

Run squint: 

```sh
$ dart bin/main.dart
```

Squint will be available as a `pub global|run` command once pub [supports][pub-async] `async`.

[issue labels]: https://developer.github.com/v3/issues/labels/
[pub-async]: http://stackoverflow.com/a/27753955
[squintrc]: https://github.com/mockturtl/squint/blob/master/.squintrc.json.example 
[.env]: https://github.com/mockturtl/squint/blob/master/.env.example
