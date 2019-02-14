.PHONY: ci autocorrect lint

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
