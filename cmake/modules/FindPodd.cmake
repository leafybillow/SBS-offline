###############################################################################
## Finds the Hall A Analyzer (PODD)
##
## Changelog:
##   * Mon Oct 08 2018 Juan Carlos Cornejo <cornejo@jlab.org>
##   - Initial find package module
###############################################################################


## Presently, we only support Podd being compiled in directory, and not
## installed anywhere else.

set(Podd_FOUND True)

set(Podd_find_library_name "HallA")
#if(DEFINED Podd_FIND_VERSION)
#  set(Podd_find_library_name ${Podd_find_library_name}.${Podd_FIND_VERSION})
#endif()

## Find the compiled shared library
find_library(Podd_LIBRARY
  NAMES ${Podd_find_library_name}
  PATHS $ENV{ANALYZER}
  )
if(Podd_LIBRARY)
  ## Get the path to the library

  get_filename_component(Podd_path ${Podd_LIBRARY} PATH)
  set(Podd_find_filenames VmeModule.h THaAnalysisObject.h)
  ## Ensure that we have the appropriate include directories
  foreach(Podd_filename ${Podd_find_filenames})
    find_path(_Podd_include_${Podd_filename}
      NAMES ${Podd_filename}
      PATHS ${Podd_path}
      PATH_SUFFIXES hana_decode src include
      NO_DEFAULT_PATH
      )
    if(_Podd_include_${Podd_filename})
      list(APPEND Podd_INCLUDE_DIR ${_Podd_include_${Podd_filename}})
    else()
      message(FATAL_ERROR "Missing required header file ${Podd_filename} in Podd/Hall A Analyzer. Please ensure that found path ${Podd_path} points to the correct directory. : ${_Podd_include_dir}")
      set(Podd_FOUND False)
    endif()
  endforeach()
else()
  set(Podd_FOUND False)
  message(FATAL_ERROR "Podd/Hall A Analyzer library not found. Please set your $ANALYZER variable accordingly.")

  ##
endif()


include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Podd DEFAULT_MSG Podd_FOUND Podd_LIBRARY Podd_INCLUDE_DIR)

#if(NOT ANALYZER_FOUND)
#  message(FATAL_ERROR "Podd/Hall A C++ Analyzer not found. Set your the environmental variable ANALYZER accordingly.")
#else()
#  set(ANALYZER_INCLUDE_DIR ${ANALYZER_PATH})
#  message(ERROR_FATAL "Podd/Hall A C++ Analyzer found in ${ANALYZER_PATH}")
#endif()


if(NOT PODD_CONFIG_EXEC)
  ## Only execute this if not already done so

  ## Wouldn't it be great if the user actually had an environmental variable
  ## set?
  if(DEFINED ENV{ANALYZER})
    set(ANALYZER_PATH $ENV{ANALYZER})
  endif()
endif(NOT PODD_CONFIG_EXEC)

mark_as_advanced(Podd_FOUND)
