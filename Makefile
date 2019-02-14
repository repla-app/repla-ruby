.PHONY: ci autocorrect lint

ci: lint
ac: autocorrect

lint:
	rubocop

autocorrect:
	rubocop -a

deploy:
	gem build repla.gemspec | grep "\s*File:" | cut -d: -f 2 | awk '{$1=$1};1' | xargs gem push
