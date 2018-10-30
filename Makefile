#=============================================
# Define script path
#=============================================

ifndef ETL_PATH
	export ETL_PATH=$(pwd)
endif

#=============================================
# Default target
#=============================================

all:
	postgresql postgis backrest pgjdbc pgaudit pgaudit_analyze set_user

#=============================================
# Targets that generate projects
#=============================================

postgresql:
	cd $(ETL_PATH)/etl/postgresql && ./run.sh

postgis:
	cd $(ETL_PATH)/etl/postgis && ./run.sh

backrest:
	cd $(ETL_PATH)/etl/backrest && ./run.sh

pgjdbc:
	cd $(ETL_PATH)/etl/pgjdbc && ./run.sh

pgaudit:
	cd $(ETL_PATH)/etl/pgaudit && ./run.sh

pgaudit_analyze:
	cd $(ETL_PATH)/etl/pgaudit_analyze && ./run.sh

set_user:
	cd $(ETL_PATH)/etl/set_user && ./run.sh
