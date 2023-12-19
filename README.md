# Overview

*View the [live version on Github Pages here](https://roboticmind.github.io/Subleq-Visualizer/)*

---

This project aims to explain what Subleq is
and how it works. It contains a written explanation
in the `index.html` file and visualization tool written in Elm that lives in the `src` folder

## Building The Visualizer

The `index.html`  page expects the elm output to
be in `visual.html`, so to build all we need to run is:

```bash
elm make elm-src/Main.elm --optimize --output=visual.html
```
