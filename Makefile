SHELL := /bin/sh

# SET THIS! Directory containing wsgi.py
# PROJECT := someproject

LOCALPATH := $(CURDIR)/src/
PYTHONPATH := $(LOCALPATH)
SETTINGS := production
TEST_SETTINGS := test
DJANGO_SETTINGS_MODULE = $(PROJECT).settings.$(SETTINGS)
DJANGO_TEST_SETTINGS_MODULE = $(PROJECT).settings.$(TEST_SETTINGS)
DJANGO_POSTFIX := --settings=$(DJANGO_SETTINGS_MODULE) --pythonpath=$(PYTHONPATH)
DJANGO_TEST_POSTFIX := --settings=$(DJANGO_TEST_SETTINGS_MODULE) --pythonpath=$(PYTHONPATH)
PYTHON_BIN := $(VIRTUAL_ENV)/bin

.PHONY: clean showenv.generic coverage test bootstrap pip virtualenv sdist

showenv.generic:
	@echo 'Environment:'
	@echo '-----------------------'
	@$(PYTHON_BIN)/python -c "import sys; print 'sys.path:', sys.path"
	@echo 'PYTHONPATH:' $(PYTHONPATH)
	@echo 'PROJECT:' $(PROJECT)
	@echo 'DJANGO_SETTINGS_MODULE:' $(DJANGO_SETTINGS_MODULE)
	@echo 'DJANGO_TEST_SETTINGS_MODULE:' $(DJANGO_TEST_SETTINGS_MODULE)

djangohelp:
	$(PYTHON_BIN)/django-admin.py help $(DJANGO_POSTFIX)

collectstatic:
	$(PYTHON_BIN)/django-admin.py collectstatic -c --noinput $(DJANGO_POSTFIX)

refresh:
	touch src/$(PROJECT)/wsgi.py

rsync:
	rsync -avz --exclude-from .gitignore --exclude-from .rsyncignore . ${REMOTE_URI}

clean:
	find . -name "*.pyc" -print0 | xargs -0 rm -rf
	rm -rf htmlcov 
	rm -rf .coverage

test: clean
	-$(PYTHON_BIN)/coverage run $(LOCALPATH)manage.py test $(DJANGO_TEST_POSTFIX)

coverage:
	$(PYTHON_BIN)/coverage html --include="$(LOCALPATH)*" --omit="*/admin.py,*/test*"

predeploy: test

register:
	python setup.py register

sdist:
	python setup.py sdist

upload: sdist
	python setup.py upload
	make clean

bootstrap: virtualenv pip

pip: requirements/$(SETTINGS).txt
	pip install -r requirements/$(SETTINGS).txt

virtualenv:
	virtualenv --no-site-packages $(VIRTUAL_ENV)
	echo $(VIRTUAL_ENV)

all: collectstatic refresh

