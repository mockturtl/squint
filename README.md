squint
======

Squint is a client for GitHub's [issue labels][gh-issue-labels] api (v3).

[![Pub Version][pub_badge]][pub]
[![Build Status][ci-badge]][ci]
[![Documentation][dartdocs-badge]][dartdocs]
[![Tickets Ready][waffle_badge]][waffle]

[ci-badge]: https://travis-ci.org/mockturtl/squint.svg?branch=master
[ci]: https://travis-ci.org/mockturtl/squint
[pub_badge]: https://img.shields.io/pub/v/squint.svg
[pub]: https://pub.dartlang.org/packages/squint
[waffle_badge]: https://badge.waffle.io/mockturtl/squint.svg?label=ready&title=Ready
[waffle]: https://waffle.io/mockturtl/squint
[dartdocs-badge]: https://img.shields.io/badge/dartdocs-reference-blue.svg
[dartdocs]: http://www.dartdocs.org/documentation/squint/latest

### about

Groom the default tags to suit your team. Try it with [Stagehand][] in a new repo.

Squint is idempotent. Requests are deduplicated against the repo's current labels.

[stagehand]: http://stagehand.pub/
[gh-issue-labels]: https://developer.github.com/v3/issues/labels/

###### setup

Create [`.env`][.env] from the template file and fill in its values.

[.env]: https://github.com/mockturtl/squint/blob/master/.env.example

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

[squintfile]: https://github.com/mockturtl/squint/blob/master/.squint.yml.example

### cli
 
Grab the latest:

```sh
$ pub global activate squint
```

Pub will install the `squint` executable. ([more][pub-global])

Run:

```sh
$ squint --help  # needs ~/.pub-cache/bin in your PATH
```

[pub-global]: https://www.dartlang.org/tools/pub/cmd/pub-global.html#running-a-script


#### discussion

Use the [issue tracker][tracker] for bug reports and feature requests.

Pull requests gleefully considered.

[tracker]: https://github.com/mockturtl/squint/issues

###### license: [MIT](LICENSE)