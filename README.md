# Crunchy Data Access Portal Conversion Scripts

This repository contains a set of scripts that perform an Extract, Transform, Load (ETL) process
on the following projects:

* pgaudit
* pgaudit_analyze
* set_user
* backrest
* postgresql
* postgis

It is important to note that naming conventions for any created project folders within each of the
repository directories (as mentioned below under Structure) must follow the spelling as written above.

For each project mentioned, the data is extracted from the respective tarball, transformed into
Markdown and parsed to clean up the content, then generated with the
[Crunchy Hugo Theme](https://github.com/CrunchyData/crunchy-hugo-theme) into a set of static
files that can be hosted on a webserver.

## Structure

The following folders are contained within this repository when everything is built out:

* /etl
* /docs
* /src
* /pdf

### /etl

The **etl** folder holds the respective conversion scripts for each aforementioned project. Each
project has its own devoted folder.

Within this folder, you'll also find the **template** folder which contains the submodule for the
[Crunchy Hugo Theme](https://github.com/CrunchyData/crunchy-hugo-theme) template. Please periodically
ensure this submodule is up-to-date.

All scripts reference the `common/common.sh` script as a basis for the clean-up functions and defined
variables.

### /docs

The **docs** folder is where the generated project websites are placed during the execution of the
`load.sh` script.

### /src

The **src** folder is where each .tar.gz for the source documentation lives. It should be nested in
the following fashion (as an example):

```sh
/src/backrest/backrest_2_05.tar.gz
/src/pgaudit_analyze/pgaudit_analyze_1_0_6.tar.gz
/src/pgaudit/pgaudit_1_2_0.tar.gz
```

and so on.

### /pdf

The **pdf** folder is where all generated PDF's of the documentation are collected. There are folders
that are created for each project, with the respective PDF files being renamed to include the version.

These PDF files are generated using `pandoc`, and include a table of contents for ease of use.

## Requirements

The PostgreSQL documentation is generated from SGML into HTML using the instructions
found [here](https://www.postgresql.org/docs/current/static/docguide.html). Any requirements for
building PostgreSQL documentation from source will need to be fulfilled before the scripts for the
PostgreSQL project will run successfully.

The PostGIS documentation is generated from source. Any requirements for building PostGIS from source 
will need to be fulfilled before the scripts for the PostGIS project will run successfully. This 
additionally applies to ensuring the `dblatex` package is installed for PDF generation.

Finally, [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/) is used for processing 
the data files, as is explained in more detail below. The minimum required version of BeautifulSoup is 4.4.0.

The version of Hugo used to test this project is v0.40. There is a known error with v0.51 that is being worked through currently.

When you're ready to build out the documentation, the you'll want to use the `conversion.sh` script
contained in the root directory.

Usage of the script:

```sh
$ ./conversion.sh

Usage: $ ./conversion.sh <project_name> <project_version>

Available project names:

- pgaudit
- pgaudit_analyze
- set_user
- backrest
- postgis
- postgresql

Available project versions:

- pgaudit: 1.0.6 | 1.1.1 | 1.2.0 | 1.3.0
- pgaudit_analyze: 1.0.7
- set_user: 1.6.1
- backrest: 1.28 | 1.29 | 2.00 | 2.01 | 2.02 | 2.03 | 2.04
- postgis: 2.2.7 | 2.3.7 | 2.4.5
- postgresql: 9.3.24 | 9.4.19 | 9.5.14 | 9.6.10 | 10.5 | 11.0

Available flags:  --no-html || --no-pdf || --all
```

## Design Standards

Within this project, you'll find the following design standards to be true:

1) All file manipulation and system administration tasks are accomplished using Bash.
2) All data reading and processing is done using Python, and more specifcially, [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/). 

## Testing

If it's necessary to test the generated output, you can run the following two scripts in the desired
project folder:

```sh
./extract.sh
./transform.sh
```

Then, change directory to `dst` and run the Hugo server module:

```sh
cd dst
hugo server
```

By default, this will make the documentation available at http://localhost:1313 but be sure to read
the output to see where it binds.
