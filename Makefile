EXTENSION = min_to_max        # the extensions name
DATA = min_to_max--0.0.1.sql  # script files to install
# postgres build stuff
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)