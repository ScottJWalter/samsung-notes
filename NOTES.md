# Project notes -- samsung-notes

_A loose assembly of information about Samsung Notes and other errata I've found while working on this. --SjW_

Files extracted from Notes have a `<TITLE>_<DATESTAMP>_<TIMESTAMP>.pdf` format, where:

* `DATESTAMP` is of the format `YYYYMMDD`
* `TIMESTAMP` is of the format `HHMMSS`
* `DATESTAMP` and `TIMESTAMP` record the time the PDF was created, **NOT** the time the note itself was created.
* `TITLE` is the note title, if one was provided.  Otherwise, it's 'Notes', 'Untitled', etc.
* For the image files created, they take the base format you provide and append '-1', '-2', etc. for each file image.

The Samsung Notes app uses SQLite to stitch together notes.  I've only started pulling that apart.
