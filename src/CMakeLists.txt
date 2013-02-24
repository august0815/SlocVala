# Vala stuff

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.18.0" MINIMUM)
include(ValaPrecompile)


# pkgconfig, real C code
find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED gtk+-3.0 gee-1.0 gio-2.0 granite)
set(CFLAGS
	${DEPS_CFLAGS} ${DEPS_CFLAGS_OTHER}
)
set(LIB_PATHS
	${DEPS_LIBRARY_DIRS}
)
link_directories(${LIB_PATHS})


add_definitions(${CFLAGS})
vala_precompile(VALA_C 
    main.vala
    Window.vala
    SLOC.vala
	slocV.vala
	slocMake.vala
	REPORT.vala
	reportSimple.vala
	
PACKAGES
    gtk+-3.0
    
    granite
OPTIONS
    --thread)

add_executable(slocvala
    ${VALA_C} )

target_link_libraries(slocvala ${DEPS_LIBRARIES})

install(TARGETS slocvala RUNTIME DESTINATION bin)
