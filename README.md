squint
======

[![Pub Version][pub_badge]][pub]
[![Build Status][ci-badge]][ci]
[![Tickets Ready][waffle_badge]][waffle]

Squint is a client for GitHub's [issue labels][] api (v3).

Groom the default tags to suit your team.

Try it with [Stagehand][] in a new repo.

[stagehand]: http://stagehand.pub/

[ci-badge]: https://travis-ci.org/mockturtl/squint.svg?branch=master
[ci]: https://travis-ci.org/mockturtl/squint
[pub_badge]: https://img.shields.io/pub/v/squint.svg
[pub]: https://pub.dartlang.org/packages/squint
[waffle_badge]: https://badge.waffle.io/mockturtl/squint.svg?label=ready&title=Ready
[waffle]: https://waffle.io/mockturtl/squint

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

- Squint is idempotent.  Requests are deduplicated against the repo's current labels.
- Squint will be available as a `pub global|run` command once pub [supports][pub-async] `async`.

[issue labels]: https://developer.github.com/v3/issues/labels/
[pub-async]: http://stackoverflow.com/a/27753955
[squintrc]: https://github.com/mockturtl/squint/blob/master/.squintrc.json.example 
[.env]: https://github.com/mockturtl/squint/blob/master/.env.example
