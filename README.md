# samsung-notes

This is a working project to extract notes from the Samsung Notes app and convert them
to markdown for inclusion elsewhere (obsidian, etc.).

There are two ways to use this project:

* [Using the `notes2md.sh` script](#using-notes2mdsh)
* [Using the `notes2md` app](#using-the-nodejs-app) (still in development)

## Using `notes2md.sh`

1. Install Poppler
2. Create your `DIR_IN`, `DIR_OUT`, and `DIR_WORK` folders and update the script with those paths.
3. Launch Samsung Notes (NOTE:  The 'hack' to get Notes working on non-Samsung platforms like Windows works perfectly for this.)
4. Select the notes you wish to extract
5. From the hamburger menu, select 'Save as file'.  This doesn't pack all notes into a single file, it creates one file per note.
6. When prompted, select `DIR_IN` as the destination folder.
7. Let it run.  Only indication you get is a badly designed, barely visible rotating animation in the center of the app.  Otherwise, monitor `DIR_IN` for the files.
8. Exit Notes and get to a terminal (I'm using WSL, so I know linux works right now), opening to this project directory 
9. Run the script `./notes2md.sh`

When done, the `DIR_IN` folder will be empty, and the `DIR_OUT` folder will have a collection of ZIP files, one file per note.  Each zip file will have a markdown file at its root, which references the PDF and PNG files in the `assets/` folder.

At this point, you can do what you want with the files, but that's beyond the scope of this converter.

## Using the nodejs app

**This is still WIP**

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
