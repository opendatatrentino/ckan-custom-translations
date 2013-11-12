##============================================================
## This makefile does many tasks:
##
##   * Aggregate .pot files from different projects
##   * Aggreagate .po translations from different projects
##   * Creates translation files from .pot + .po
##   * Compiles .po -> .mo
##============================================================

## ---- % begin configuration % ----

## Note: you can override configuration variables
##       by passing them on the ``make`` command line:
##
##  make SOURCESDIR=/path/to/src PLUGINS="one two" LANGUAGES="en_GB it fr de"

## We expect to find ``ckan`` and ``ckanext-{plugin}``
## for each plugin in this directory.
SOURCESDIR := $(HOME)/Projects/dati-trentino-2

## List of plugin names
PLUGINS := datitrentinoit

## Languages to consider for translations
LANGUAGES := it en_GB

## ---- % end configuration % ----


## Source .pot files for translations
SOURCE_POTS := i18n/custom.pot $(SOURCESDIR)/ckan/ckan/i18n/ckan.pot
SOURCE_POTS += $(foreach plugin,$(PLUGINS),$(SOURCESDIR)/ckanext-$(plugin)/ckanext/$(plugin)/i18n/ckanext-$(plugin).pot
ALL_POT := i18n/all_%.po

## Source .po files for translations
SOURCE_POS := i18n/%/LC_MESSAGES/ckan.po \
              $(SOURCESDIR)/ckan/ckan/i18n/%/LC_MESSAGES/ckan.po
SOURCE_POS += $(foreach plugin,$(PLUGINS),$(SOURCESDIR)/ckanext-$(plugin)/ckanext/$(plugin)/i18n/%/LC_MESSAGES/ckanext-$(plugin).po)
ALL_PO := i18n/all_%.po
ALL_PO_TARGETS := $(foreach lang,$(LANGUAGES),aggregate_pos_$(lang))

## Custom .po for a language
CUSTOM_PO := i18n/%/LC_MESSAGES/ckan.po
CUSTOM_PO_TARGETS := $(foreach lang,$(LANGUAGES),custom_po_$(lang))

## Actual .po/.mo files to build
CUSTOM_PO_FILES := $(foreach lang,$(LANGUAGES),i18n/$(lang)/LC_MESSAGES/ckan.po)
MO_TARGETS := $(patsubst %.po,%.mo,$(CUSTOM_PO_FILES))


all: $(MO_TARGETS)


##------------------------------------------------------------
## POT aggregation

aggregate_pots: $(ALL_POT)

## Merge .pot files by concatenating all the .pots
$(ALL_POT): $(SOURCE_POTS)
	@echo "Merging .pot files"
	msgcat --use-first $^ -o $@


##------------------------------------------------------------
## PO aggregation
## This is a bit tricky, as we need to aggregate
## A, B and C into A..

aggregate_pos_%: $(ALL_PO)

## Create an aggregate .po file by merging all the translations
$(ALL_PO): $(SOURCE_POS)
	@echo "Creating aggregate .po file"
	msgcat --use-first $^ -o $@


##------------------------------------------------------------
## Create new custom translation, filling the new .pot
## with aggregate .po, for this language

custom_po_%: $(CUSTOM_PO)

$(CUSTOM_PO): $(ALL_PO) $(ALL_POT)
	@echo "Merging translations in new .pot file"
	msgmerge $^ -o $@


##------------------------------------------------------------
## Compile .po files into .mo files

build_mo: $(MO_TARGETS)

$(MO_TARGETS): %.mo: %.po
	msgfmt $< -o $@


##------------------------------------------------------------
## Clean up garbage

clean:
	rm -f $(MO_TARGETS)
	rm -f $(CUSTOM_PO_FILES)
	rm -f $(ALL_POT)
