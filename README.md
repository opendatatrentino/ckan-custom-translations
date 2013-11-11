# Ckan - custom translations

This project contains custom string translations for Ckan,
along with tools for maintaining translation merging etc.

In order to use the custom translations, simply add a
``ckan.i18n_directory`` configuration key, pointing to the
root of the repository, in the ``[app:main]`` section of
the main configuration file.


## How does it work

The ``Makefile`` purpose is to:

* aggregate translation templates from .pot files in ckan core
  and extensions, plus some custom strings in ``custom.pot``

* merge translations from the core and extension .po files,
  along with custom translations, in the custom translations file.

  This is a bit tricky, since we have to do something like:

  ```
  msgcat --use-first custom.po ckan.po ext.po | msgmerge - all.pot > custom.po.new
  mv custom.po.new custom.po
  ```


## How to make extensions translatable?

**todo:** write this


## Known issues

We have some issues to solve with strings not being
extracted from templates (eg. ``Categories`` is not getting
extracted, although present twice..)
