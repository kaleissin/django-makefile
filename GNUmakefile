include Makefile

ifndef VIRTUAL_ENV

$(error VIRTUAL_ENV not set)

else

PATH := $(VIRTUAL_ENV)/bin:$(PATH)
export $(PATH)
showenv: showenv.generic
	echo 'VIRTUAL_ENV:' $(VIRTUAL_ENV)
	echo 'PATH:' $(PATH)

endif
