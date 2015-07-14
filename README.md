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

Create [`.squint.yml`][squintfile] (or `.json`) with the issue labels you wish 
to add, remove, or change.

```yaml
remove:
  - help wanted
  - invalid
  - question
  - enhancement

add: 
  - name: blocked
    color: '#800000'
  - name: ready
    color: '#01ff70'
  - name: android
    color: '#a4c639'
  - name: jigglypuff
    color: '#fad0de'

change:
  - name: bug
    color: '#d32f2f'
  - name: wontfix
    color: '#000000'
  - name: duplicate
    color: '#433333'
```

run 
---

Grab the latest:

```sh
$ pub global activate squint
```

Then:

```sh
$ squint -f .squint.yml
```

Squint is idempotent.  Requests are deduplicated against the repo's current labels.

[issue labels]: https://developer.github.com/v3/issues/labels/
[squintfile]: https://github.com/mockturtl/squint/blob/master/.squint.yml.example 
[.env]: https://github.com/mockturtl/squint/blob/master/.env.example
