.PHONY: ci ac autocorrect lint deploy test loc

ci: lint
ac: autocorrect

lint:
	rubocop

autocorrect:
	rubocop -a

deploy:
	[[ $(shell git rev-parse --abbrev-ref HEAD) == "master" ]] \
		&& gem build repla.gemspec \
		| grep "\s*File:" \
		| cut -d: -f 2 \
		| xargs gem push

test:
	./test/run_tests.sh

loc:
	cloc --vcs=git --not-match-f='(handlebars|mousetrap|zepto|chai|mocha)\.js'
