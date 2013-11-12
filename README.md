# Ckan - custom translations

This project contains custom string translations for Ckan,
along with tools for maintaining translation merging etc.


## Updating translation strings

Strings get merged this way:

* Aggregate all ``.pot``s from a bunch of projects

* Aggreagate all ``.po``s from a bunch of projects, separated
  by language

* Generate custom ``.po`` file for each language,
  by merging all the translations into the new template
  (including translations from the custom file itself)


## Usage

* Create a directory and checkout ckan + the plugins you need
  inside the directory.

  **Important** the Makefile expects to find a directory
  named ``ckan/ckan/i18n`` in the sources directory, plus
  directories named ``ckanext-<name>/ckanext/<name>/i18n`` for
  each plugin. Make sure you have them

* Prepare ``.po`` files for each extra language you want to add:

  ```
  touch i18n/<lang-code>/LC_MESSAGES/ckan.po
  ```

  (this is required as the file is included in the custom
  translations too..)

* Call make:

  ```
  make SOURCESDIR=/path/to/sources LANGUAGES="en_GB it es de fr" PLUGINS="one two three"
  ```

* Translate strings:

  ```
  $EDITOR i18n/<lang-code>/LC_MESSAGES/ckan.po
  ```

* Then, rebuild the ``.mo`` files:

  ```
  make build_mo LANGUAGES="en_GB it es de fr"
  ```

## Make Ckan load custom translations

This can be done by setting the ``ckan.i18n_directory`` configuration
option (in the ``[app:main]`` section of ckan configuration file)
to point to the root directory of  this repository (or any directory
containing a copy of the ``i18n`` folder, for what matters).


## How to make extensions translatable?

**todo:** write this
