asdf_setup:
	asdf install
	python -m venv .venv
	source .venv/bin/activate

test: asdf_setup
	python -m pytest tests -v

lint: asdf_setup
	flake8 .

format: asdf_setup
	black .
