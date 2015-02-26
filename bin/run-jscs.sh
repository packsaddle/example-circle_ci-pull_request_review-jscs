#!/bin/bash
set -v
if [ -n "${TRAVIS_PULL_REQUEST}" ] && [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  # Travis-CI
  #
  # git clone --depth=50 \
  # git://github.com/packsaddle/example-ruby-travis-ci.git \
  # packsaddle/example-ruby-travis-ci
  # cd packsaddle/example-ruby-travis-ci
  # git fetch origin +refs/pull/1/merge:
  # git checkout -qf FETCH_HEAD

  echo gem install
  gem install --no-document checkstyle_filter-git saddler saddler-reporter-github

  echo git diff
  git diff --name-only origin/master

  echo file grep
  git diff --name-only origin/master \
   | grep -E '*.js$'

  echo jscs
  git diff --name-only origin/master \
   | grep -E '*.js$' \
   | xargs ./node_modules/gulp-jscs/node_modules/.bin/jscs \
       --reporter checkstyle

  echo checkstyle_filter-git
  git diff --name-only origin/master \
   | grep -E '*.js$' \
   | xargs ./node_modules/gulp-jscs/node_modules/.bin/jscs \
       --reporter checkstyle \
   | checkstyle_filter-git diff origin/master

  echo saddler
  git diff --name-only origin/master \
   | grep -E '*.js$' \
   | xargs ./node_modules/gulp-jscs/node_modules/.bin/jscs \
       --reporter checkstyle \
   | checkstyle_filter-git diff origin/master \
   | saddler report \
      --require saddler/reporter/github \
      --reporter Saddler::Reporter::Github::PullRequestReviewComment
fi

exit 0
