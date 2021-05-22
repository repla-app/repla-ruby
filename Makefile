.PHONY: ci ac autocorrect lint deploy test loc gem_install

ci: gem_install lint
ac: autocorrect

lint:
	bundle exec rubocop

autocorrect:
	bundle exec rubocop -a

gem_install:
	bundle install --path vendor/bundle

deploy:
	[[ $(shell git rev-parse --abbrev-ref HEAD) == "master" ]] \
		&& gem build repla.gemspec \
		| grep "\s*File:" \
		| cut -d: -f 2 \
		| xargs gem push

test:
	./test/run_tests.sh

loc:
	cloc --vcs=git --not-match-f='(handlebars|jquery|mousetrap|zepto|chai|mocha)\.js'
