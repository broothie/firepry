
help:
	@ cat Makefile

bump:
	bump lib/firepry.rb

local: clean
	gem build
	gem install firepry-*.gem

clean:
	rm -rf firepry-*.gem
