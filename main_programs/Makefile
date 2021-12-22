MOD_DIR := ../modules/

OPTIONS := -I $(MOD_DIR) -J $(MOD_DIR) -g -fcheck=all -Wall -Wextra -pedantic \
-std=f2003 -O3 -c

MODULES := $(wildcard $(MOD_DIR)*.f90)
OBJECTS := $(patsubst %.f90,%.o,$(MODULES))

SRC := filename
OBJ := $(patsubst %.f90,%.o,$(SRC))
EXE := $(patsubst %.f90,%.exe,$(SRC))

$(EXE): $(OBJ)
	gfortran -o $@ $< $(OBJECTS)
$(OBJ): $(SRC) $(OBJECTS)
	gfortran $(OPTIONS) $< -o $@
$(OBJECTS): $(MOD_DIR)%.o: $(MOD_DIR)%.f90
	gfortran $(OPTIONS) $< -o $@
