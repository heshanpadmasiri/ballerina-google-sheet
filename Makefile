##
# Ballerina Google Sheet client
#
# @file
# @version 0.1

BAL?=bal
TARGETS=all clean test
SUBDIRS=client.d

# This needs to control the order in which we build the JARS
all:
	$(MAKE) target=all client.d

test clean:
	$(MAKE) target=$@ $(SUBDIRS)

test: all

$(SUBDIRS):
	$(MAKE) -C $(basename $@) $(target)

.PHONY: $(TARGETS) $(SUBDIRS)
# end
