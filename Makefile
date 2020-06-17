.PHONY: install serve

install:
	bundle install

serve:
	bundle exec rails server --binding 0.0.0.0
