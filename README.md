# example-travis_ci-pull_request_review-jscs

run jscs and pull request review comment

[Actual script for CircleCI](./bin/run-jscs.sh)

```
# circle.yml
test:
  pre:
    - bin/run-jscs.sh

# bin/run-jscs.sh
#!/bin/bash
set -v
if [ "${CIRCLE_BRANCH}" != "master" ]; then
  gem install --no-document checkstyle_filter-git saddler saddler-reporter-github

  git diff --name-only origin/master \
   | grep '.*\.js$' \
   | xargs ./node_modules/gulp-jscs/node_modules/.bin/jscs \
       --reporter checkstyle \
   | checkstyle_filter-git diff origin/master \
   | saddler report \
      --require saddler/reporter/github \
      --reporter Saddler::Reporter::Github::PullRequestReviewComment
fi

exit 0
```

If you prefer to exec *post* `test`, you can set this. See: [Configuring CircleCI - CircleCI](https://circleci.com/docs/configuration#phases)

## Setting

[Environment variables - CircleCI](https://circleci.com/docs/environment-variables)

set your own `GITHUB_ACCESS_TOKEN`


## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [gulp](http://gulpjs.com/).


## License

Copyright (c) 2015 sanemat. Licensed under the MIT license.
