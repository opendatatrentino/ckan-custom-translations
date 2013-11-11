# Compile messages

TARGETS := i18n/it/LC_MESSAGES/ckan.mo \
	   i18n/en_GB/LC_MESSAGES/ckan.mo

## Note: this should be set from environment:
## make SOURCESDIR=/path/to/sources/root
SOURCESDIR := $(HOME)/Projects/dati-trentino-2

# Source .po files for translations
SOURCE_POS := $(SOURCESDIR)/ckan/ckan/i18n/%/LC_MESSAGES/ckan.po \
              $(SOURCESDIR)/ckanext-datitrentinoit/ckanext/datitrentinoit/i18n/%/LC_MESSAGES/ckanext-datitrentinoit.po


all: $(TARGETS)

i18n/%/LC_MESSAGES/ckan.po: $(SOURCE_POS)
	@echo "Compiling" $^ "to" $@
	./merge-messages.sh $@ $^

$(TARGETS): %.mo: %.po
	msgfmt $< -o $@

clean:
	rm -f $(TARGETS)
