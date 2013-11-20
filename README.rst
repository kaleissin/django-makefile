===============
django-makefile
===============                                                                 

Makefile templates to aid in development and deployment of Django sites         
                                                                                
Why Make?
---------                                                                                                                                                                     

Because it's there.                                                             
                                                                                
Because calling commands from a file hosted with the rest of the source         
greatly simplifies deployment scripts. The deployment script need know          
of fewer paths.                                                                 
                                                                                
Because

::

    cd someproject-dir
    make test

is easier to type than

::

    django-admin.py test --settings=someproject.settings.test --pythonpath=/path/to/project/src

especially on the Monday the first working day after your vacation.

Because ``fabric`` gave me indigestion.


Deployment
----------

Currently I use a shell script, something along the lines of::

    #!/bin/bash
    
    PROJECT_HOME="/path/to/project"
    REMOTE="user@remote.machine.some.domain"
    REMOTE_HOME="/path/on/remote/machine"
    REMOTE_VENV="/path/to/remote/virtualenv"
    LOCAL_VENV="/path/to/local/virtualenv"
    SECRET_KEY='production_secret_key_whatever_that_is'
    REMOTE_PREFIX="export SECRET_KEY='${SECRET_KEY}' "
    REMOTE_MAKE="${REMOTE_PREFIX} && make -C ${REMOTE_HOME} VIRTUAL_ENV=${REMOTE_VENV}"
    LOCAL_MAKE="make -C ${PROJECT_HOME} VIRTUAL_ENV=${LOCAL_VENV} "
    
    ${LOCAL_MAKE} REMOTE_URI=${REMOTE}:${REMOTE_HOME} rsync
    
    ssh ${REMOTE} "${REMOTE_MAKE} all"

This is not under version control since it needs to be updated per project, 
per client machine, and per remote machine.


Most Useful Targets
-------------------

cmd:
    Runs any django command with production settings (in the CMD variable)

refresh:
    Touches the wsgi-file, thereby refreshing/reloading the site

showenv:
    Dumps some relevant environment variables

djangohelp:
    Runs ``django-admin.py help``

test:
    Runs all tests

bootstrap:
    Sets up a virtualenv and runs pip, provided there's a requirements-file

all:
    Regenerates static files and reloads the site
