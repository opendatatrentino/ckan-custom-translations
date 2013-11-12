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

First, create a babel configuration file, in the root of your
extension folder:

```cfg
[jinja2: **/templates/**.html]
encoding = utf-8
extensions =
  jinja2.ext.do,
  jinja2.ext.i18n,
  jinja2.ext.with_,
  ckan.lib.jinja_extensions.CkanExtend,
  ckan.lib.jinja_extensions.CkanInternationalizationExtension,
  ckan.lib.jinja_extensions.LinkForExtension,
  ckan.lib.jinja_extensions.ResourceExtension,
  ckan.lib.jinja_extensions.SnippetExtension,
  ckan.lib.jinja_extensions.UrlForExtension,
  ckan.lib.jinja_extensions.UrlForStaticExtension
```

Then, add jinja extractor (or, would have you guessed that, **ckan** extractor..)
as entry point in your ``setup.py``.

```python
entry_points = {
    'babel.extractors': [
        'ckan = ckan.lib.extract:extract_ckan',
    ],
}

setup(
    ...
    entry_points=entry_points,
)
```

Finally, create a ``setup.cfg`` file to tell the setuptools' babel extension commands
where to search for stuff and where to put other stuff.

```cfg
[extract_messages]
keywords = translate isPlural
add_comments = TRANSLATORS:
output_file = ckanext/myplugin/i18n/ckanext-myplugin.pot
width = 80
mapping_file = babel.cfg

[init_catalog]
domain = ckanext-myplugin
input_file = ckanext/myplugin/i18n/ckanext-myplugin.pot
output_dir = ckanext/myplugin/i18n

[update_catalog]
domain = ckanext-myplugin
input_file = ckanext/myplugin/i18n/ckanext-myplugin.pot
output_dir = ckanext/myplugin/i18n
previous = true

[compile_catalog]
domain = ckanext-myplugin
directory = ckanext/myplugin/i18n
statistics = true
```

### Collecting strings & starting translating

Ok, now that everything is in place, try to see if everything works
as expected:

```
python setup.py extract_messages
```

will extract all the strings in ``ckanext/myplugin/i18n/ckanext-myplugin.pot``

```
python setup.py init_catalog -l it
```

will create a ``.po`` file for the Italian language, in
``ckanext/myplugin/i18n/it/LC_MESSAGES/ckanext-myplugin.po``

Then, you can start translating strings.

Once you're done, just run:

```
python setup.py compile_messages
```

in order to (re)build ``.mo`` files from the ``.po``s.


### Updating strings

In case you edit strings in your templates, just use this to keep
up-to-date:

```
python setup.py extract_messages
python setup.py update_messages
```

then translate, and, of course, run ``compile_messages`` again.


## Debugging problems with messages

It seems that babel simply ignores errors encountered while scanning
for messages. This tends to hide some issues that lead to missing
strings.

To figure out the issues, I used this:

```python
extensions = [
    "jinja2.ext.do",
    "jinja2.ext.i18n",
    "jinja2.ext.with_",
    "ckan.lib.jinja_extensions.CkanExtend",
    "ckan.lib.jinja_extensions.CkanInternationalizationExtension",
    "ckan.lib.jinja_extensions.LinkForExtension",
    "ckan.lib.jinja_extensions.ResourceExtension",
    "ckan.lib.jinja_extensions.SnippetExtension",
    "ckan.lib.jinja_extensions.UrlForExtension",
    "ckan.lib.jinja_extensions.UrlForStaticExtensio"n
]
env = Environment(extensions=extensions)
with open('/path/to/templates/blah/index.html', 'r') as f:
    template = f.read()
strings = env.extract_translations(template)
```

You can inspect ``strings`` to see if all the expected strings are there,
and in case the extractor has troubles, an exception will be raised,
allowing you to see what went wrong.
