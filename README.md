# samsung-notes

This is a working project to extract notes from the Samsung Notes app and convert them
to markdown for inclusion elsewhere (obsidian, etc.).

There are two ways to use this project:

* [Using the `notes2md.sh` script](#using-notes2mdsh)
* [Using the `notes2md` app](#using-the-nodejs-app) (still in development)

## Using `notes2md.sh`

1. Install [Poppler](https://poppler.freedesktop.org/)

2. Create your `data_root`, which should have 3 subdirectories:

```
     data_root\
        +in\
        +out\
        +work\
```

3. Launch Samsung Notes (NOTE:  The [hack](https://github.com/ChristianAndrango/Samsung-Notes) to get Notes working on non-Samsung platforms like Windows works perfectly for this.)
4. Select the notes you wish to extract
5. From the hamburger menu, select 'Save as file'.  This doesn't pack all notes into a single file, it creates one file per note.
6. When prompted, select `${data_root}/in` as the destination folder.
7. Let it run.  Only indication you get is a badly designed, barely visible rotating animation in the center of the app.  Otherwise, monitor `${data_root}/in` for the files.
8. Exit Notes and get to a terminal (I'm using WSL, so I know linux works right now), opening to this project directory 
9. Run the script `./notes2md.sh`

When done, the `${data_root}/in` folder will be empty, and the `${data_root}/out` folder will have a collection of ZIP files, one file per note.  Each zip file will have a markdown file at its root, which references the PDF and PNG files in the `assets/` folder.

At this point, you can do what you want with the files, but that's beyond the scope of this converter.

### Caveat(s)

* The generated PDF (for that matter, any of the output formats) doesn't push any metadata from the note out.
* The timestamp in the filename is the time the PDF *was generated*, **not** when the note was originally created.  
* Metadata is buried inside the SQLite DB  Notes uses, which I haven't dug into (yet).

## Using the nodejs app

_**This is still WIP**_

### Usage

To install dependencies:

```bash
bun install
```

To run:

```bash
bun run index.ts
```

## Acknowledgements

This project was created using `bun init` in bun v1.1.24. [Bun](https://bun.sh) is a fast all-in-one JavaScript runtime.
