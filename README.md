# Crunchy Data Access Portal Conversion Scripts

This repository contains a set of scripts that perform an Extract, Transform, Load (ETL) process
on the following projects:

* amcheck_next
* backrest
* crunchy_postgresql_for_pcf
* check_postgres
* patroni
* pg_cron
* pgadmin4
* pgaudit
* pgaudit_analyze
* pgbadger
* pgbouncer
* pgjdbc
* pgmonitor
* pg_partman
* pgpool
* pgrouting
* pgstigcheck-inspec
* plr
* postgis
* postgres_operator
* postgresql
* psycopg2
* sec_install_n_config
* set_user

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
* /epub

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

These PDF files are generated using `pandoc` or `wkhtmltopdf` in most cases where it cannot be generated organically from source, and generally include a table of contents for ease of use.

### /epub

The **epub** folder is where all generated EPUB's of the documentation are collected. There are folders
that are created for each project, with the respective EPUB files being renamed to include the version.

These EPUB files are generated using `pandoc`, and generally include a table of contents for ease of use.

## Requirements

### General

[BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/) is used for processing
the data files, as is explained in more detail below. The minimum required version of BeautifulSoup is 4.4.0.

### PostgreSQL

The PostgreSQL documentation is generated from SGML into HTML using the instructions
found [here](https://www.postgresql.org/docs/current/static/docguide.html). Any requirements for
building PostgreSQL documentation from source will need to be fulfilled before the scripts for the
PostgreSQL project will run successfully.

### PostGIS

The PostGIS documentation is generated from source. Any requirements for building PostGIS from source
will need to be fulfilled before the scripts for the PostGIS project will run successfully. This
additionally applies to ensuring the `dblatex` package is installed for PDF generation.

### Patroni

```sh
sudo yum -y install python-sphinx pdflatex texlive-framed texlive-threeparttable texlive-wrapfig
```

### pgPool

```sh
sudo yum -y install openjade
sudo yum -y install docbook-dtds docbook-style-dsssl docbook-xsl
sudo yum -y install libxslt
```

### pgAdmin4

```sh
sudo yum -y install mesa-libGL-devel gcc-c++ qt5-qtbase-devel
sudo yum -y install qt-devel qtwebkit-devel
sudo yum -y install python34 python34-libs python34-devel python-rpm-macros python-srpm-macros python3-rpm-macros python-devel
sudo yum -y install python-jinja2
sudo yum -y install python2-pytest pytest python-docutils python-py python-pygments python-sphinx
```

### pgBackRest

First, make sure Docker is installed & set up - for later versions of pgBackRest, the documentation is built
using the included Perl script `doc.pl` which calls a Docker container.

```sh
sudo yum -y install docker
sudo groupadd docker
sudo usermod -a -G docker <username>
sudo systemctl enable docker.service
sudo systemctl start docker.service
```

Then, install some Perl requirements:

```sh
sudo yum install -y yum cpanminus
sudo yum groupinstall -y "Development Tools" "Additional Development"
sudo cpanm install --force XML::Checker::Parser
```

As part of the output, the following may appear:

```sh
!  ==> Fatal error occurred, no output PDF file produced!
```

This is a known & expected error, and is produced as part of the `doc.pl` script. This does **not** affect PDF
functionality for the purposes of the Access Portal.

## Conversion Script

When you're ready to build out the documentation, the you'll want to use the `conversion.sh` script
contained in the root directory.

Usage of the script:

```sh
Usage: $ ./conversion.sh [project_name] [project_version] [flags] (baseURL)

Example of a command:

./conversion.sh pgaudit 1.3.0 --all /examplesite/project

Available project names:

   amcheck_next
   backrest
   patroni
   pgadmin4
   pgaudit
   pgaudit_analyze
   pgbadger
   pgbouncer
   pg_partman
   pgjdbc
   pgmonitor
   pgpool
   pgrouting
   pgstigcheck-inspec
   plr
   postgis
   postgres-operator
   postgresql
   psycopg2
   sec_install_n_config
   set_user

Available project versions:

   All project versions available to be converted.
   Ensure the version number takes the format X.X.X, using periods as separators.

Available flags:

   --pdf
   --epub
   --html
   --all

 If baseURL is not specified, the default of \$PROJECT_NAME/\$PROJECT_VERSION is used.

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
