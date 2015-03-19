#!/bin/bash
set -v
if [ "${CIRCLE_BRANCH}" != "master" ]; then
  # Circle-CI
  #
  echo gem install
  gem install --no-document checkstyle_filter-git saddler saddler-reporter-github

  echo git diff
  git diff --name-only origin/master

  echo file grep
  git diff --name-only origin/master \
   | grep '.*\.js$'

  echo jscs
  git diff --name-only origin/master \
   | grep '.*\.js$' \
   | xargs ./node_modules/gulp-jscs/node_modules/.bin/jscs \
       --reporter checkstyle

  echo checkstyle_filter-git
  git diff --name-only origin/master \
   | grep '.*\.js$' \
   | xargs ./node_modules/gulp-jscs/node_modules/.bin/jscs \
       --reporter checkstyle \
   | checkstyle_filter-git diff origin/master

  echo saddler
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
