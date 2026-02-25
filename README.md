# RECAP Template: Stata - Medium

## Purpose

This repository is a **[RECAP](https://recap-org.github.io)** template for **medium academic data projects using R**, such as final course projects, applied methods assignments, or replication exercises using raw data.

It provides a ready-to-use project structure and a reproducible execution environment that can be run:
- directly in the browser (e.g., GitHub Codespaces),
- or locally in common IDEs such as VS Code, Positron, or RStudio.

For guidance on how to run this template, choose an environment, or collaborate with others, see the main [RECAP documentation](https://recap-org.github.io).

## Getting started

To get started, click the **Use this template** button above the file list ⬆️.

You have two options: 

### Try it out online (without saving your work)

1. Select **Open in a codespace**. 
2. Wait for the codespace to be created and started. **This may take up to 5 minutes.** ☕
3. Once the codespace is ready, you can follow the instructions in the **Basic demo** section below.

### Make your own copy (to save your work)

If you want to keep working on this project (locally or in the cloud), create your own copy of the template.

The RECAP documentation explains:
- how to create your own repository,
- how to run the template in the cloud, locally or in an isolated environment (⚠️ isolated environment not supported on macOS),
- and how to choose the setup that fits your needs.

➡️ See **[How to run a RECAP template](https://recap-org.github.io/docs/running-templates/)** on the RECAP website.

## Using Stata in Codespaces and in isolated environments

Codespaces and isolated environments (Docker dev containers) providing a valid license. We provide access to the Stata graphical interface in your browser. 

**⚠️ for this template, isolated environments (i.e., DockDocker dev containers) are not supported on macOS.**

### Entering your license information

1. Copy `stata.lic.example` to `stata.lic`
2. Fill it using information from your Stata license PDF
3. Open a Terminal and run: `install-stata-license`

### Using the Stata graphical interfance

To open the Stata graphical interface, open a Terminal and run

```bash 
stata-gui
```

Then, click on the provided link to open Stata in your browser.

## Demo

First, install the packages used in this template. Open a terminal and type:

```bash
stata-mp -b requirements.do
```

Alternatively, you can open Stata and run `./requirements.do`

Then, open a terminal and type: 

```bash
make
```

This will execute the data cleaning step in `./src/data.do`, then the analysis step in `./src/main.do`, and finally render the TeX file in `./tex/article`. You will find the rendered PDF in `./out/article.df` and intermediary reports of the data cleaning and analysis steps in the `./out/src` directory.

## Using this template

This template is organized as follows

```bash
├── LICENSE # license file
├── README.md # this file
├── assets
│   ├── figures # where generated figures go (not committed to git)
│   ├── tables # where generated tables go (not committed to git)
│   ├── static # where external images and other static assets live (committed to git)
│   └── references.bib # latex bibliography file (committed to git)
├── data
│   ├── raw # raw data goes here (committed to git)
│   └── processed # processed data goes here (not committed to git)
├── src # all the code goes here
│   ├── data.do # process raw data into clean data
│   ├── main.do # generate the final report
│   └── lib # helper functions
├── out # where generated outputs are stored (not committed to git)
├── requirements.do # records packages used in the project
├── stata.lic # your Stata license information
└── .devcontainer # configuration for the containerized environment
```

### Producing the report

This template uses `make` to orchestrate the different steps of the analysis.  
If you are not familiar with `make`, we strongly recommend reading the following page first: [Building your project with make](https://recap-org.github.io/docs/building-with-make)

What follows focuses on how this template is structured, not on how `make` works internally.

#### Step 1: cleaning raw data

Raw data should be placed in the `./data/raw` directory and committed to git (unless it is very large, in which case you should consider alternative storage solutions).

The file `./src/data.do` turns raw data into clean, processed data.  
The processed data is written to the `./data/processed` directory.

#### Step 2: doing the analysis

The file `./src/main.do` produces the tables and figures used in the report. These tables and figures are stored in `./assets/tables` and `./assets/figures`.

### Running the full analysis

To run the full analysis from scratch, use:

```bash
make
```

This command executes both steps in the correct order:
1. run `./src/data.do`,
2. run `./src/main.do`.
3. compile `./out/article/main.tex`.

Every RECAP template also provides a built-in way to discover available commands.  
If you are unsure how to interact with the project, start by running:

```bash
make
```

You can customize `./Makefile` to change how the build steps are executed.  
For an overview of the design principles behind this setup, see the `make` documentation linked above.

### External assets

A project may also use assets that are not generated by code (e.g., external images, bibliography, ...). These should be placed in `./assets/static` and committed to git. 

### Helper functions

Helper functions are shared across your data and analysis code. They are declared in `.do` files that are placed in `./src/lib`. Think of these helper functions as a quasi independent package that accompanies the project. As such, each of these functions should be properly documented so that all collaborators understand how they work.  

### Tests

This template includes a basic testing setup written using `.do` files.

If you are not familiar with how testing works in RECAP, we recommend first reading our [documentation on tests](https://recap-org.github.io/docs/tests).

All test files must:

- live in the `tests/` directory, and
- have filenames that start with `test-`.

To run all tests, use:

```bash
make tests
```

To write other tests, feel free to copy and modify the existing tests.


## Software environment

This template comes with a reproducible execution environment that includes Stata, LaTeX, and other useful tools. We rely on the [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers) specification, which means that you can extend the environment by editting `./.devcontainer/devcontainer.json`.

The exact software stack (including versions) is documented in the **[RECAP 2026-q1 image release](https://github.com/recap-org/images/releases/tag/2026-q1)**.

This information is mainly useful if you need to check versions or debug environment-specific issues.  
You do not need to understand or modify this to use the template.

## Issues and feedback

If something doesn't work as expected, or if you have a suggestion for improving this template, please open an issue on this repository (Issue tab ⬆️).

You don't need to be sure that something is "really a bug" — unclear instructions, confusing behavior, or small setup problems are all worth reporting. Your feedback helps improve RECAP for everyone.

## Credits

We thank 

- [Jason Leung](https://unsplash.com/@ninjason?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) on [Unsplash](https://unsplash.com/photos/donkey-kong-arcade-game-screen-with-1981-date-c5tiCWrZADc?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash) for that nice Donkey Kong photo.
- [grandmaster07](https://www.kaggle.com/grandmaster07) for the student exam score dataset analysis published on [Kaggle](https://www.kaggle.com/datasets/grandmaster07/student-exam-score-dataset-analysis)
- [AEADataEditor](https://github.com/AEADataEditor) for the [Stata image](https://hub.docker.com/r/dataeditors/stata19_5-mp-x) we use our containerized environment.
