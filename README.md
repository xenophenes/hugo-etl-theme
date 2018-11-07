# Crunchy Data Access Portal Conversion Scripts

This repository contains a set of scripts that perform an Extract, Transform, Load (ETL) process
on the following projects:

* pgaudit
* pgaudit_analyze
* set_user
* backrest
* postgresql
* postgis
* pgjdbc

It is important to note that naming conventions for any created project folders within each of the
repository directories (as mentioned below under Structure) must follow the spelling as written above.

For each project mentioned, the data is extracted from the respective tarball, transformed into
Markdown and parsed to clean up the content, then generated with the
[Crunchy Hugo Theme](https://github.com/CrunchyData/crunchy-hugo-theme) into a set of static
files that can be hosted on a webserver.

## Structure

The following folders are contained within this repository:

* /etl
* /docs
* /src

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

## Requirements

You will need to set the following variable in `.bashrc` for the project scripts to correctly find
file paths:

```sh
export ETL_PATH=/path/to/repostory
```

Additionally, the PostgreSQL documentation is generated from SGML into HTML using the instructions
found [here](https://www.postgresql.org/docs/current/static/docguide.html). Any requirements for
building PostgreSQL documentation from source will need to be fulfilled before the scripts for the
PostgreSQL project will run successfully.

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
