option(USE_GCOV "Enable gcov support" OFF)

if(USE_GCOV)
  if(CLANG_TSAN)
    # GCOV and TSAN results in false data race reports
    message(FATAL_ERROR "USE_GCOV cannot be used with CLANG_TSAN")
  endif()
  message(STATUS "Enabling gcov support")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} --coverage")
  add_definitions(-DUSE_GCOV)
endif()

if(WIN32)
  if(MINGW)
    # Enable wmain
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -municode")
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework CoreServices")
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -framework CoreServices")
endif()

set(GENERATOR_DIR ${CMAKE_CURRENT_LIST_DIR}/generators)
set(GENERATED_DIR ${PROJECT_BINARY_DIR}/src/nvim/auto)
set(BINARY_LIB_DIR ${PROJECT_BINARY_DIR}/lib/nvim/)
set(API_DISPATCH_GENERATOR ${GENERATOR_DIR}/gen_api_dispatch.lua)
set(API_UI_EVENTS_GENERATOR ${GENERATOR_DIR}/gen_api_ui_events.lua)
set(GENERATOR_C_GRAMMAR ${GENERATOR_DIR}/c_grammar.lua)
set(GENERATOR_HASHY ${GENERATOR_DIR}/hashy.lua)
set(API_METADATA ${PROJECT_BINARY_DIR}/api_metadata.mpack)
set(FUNCS_DATA ${PROJECT_BINARY_DIR}/funcs_data.mpack)
set(LUA_API_C_BINDINGS ${GENERATED_DIR}/lua_api_c_bindings.generated.c)
set(HEADER_GENERATOR ${GENERATOR_DIR}/gen_declarations.lua)
set(GENERATED_INCLUDES_DIR ${PROJECT_BINARY_DIR}/include)
set(GENERATED_API_DISPATCH ${GENERATED_DIR}/api/private/dispatch_wrappers.generated.h)
set(GENERATED_FUNCS_METADATA ${GENERATED_DIR}/api/private/funcs_metadata.generated.h)
set(GENERATED_UI_EVENTS ${GENERATED_DIR}/ui_events.generated.h)
set(GENERATED_UI_EVENTS_CALL ${GENERATED_DIR}/ui_events_call.generated.h)
set(GENERATED_UI_EVENTS_REMOTE ${GENERATED_DIR}/ui_events_remote.generated.h)
set(GENERATED_UI_EVENTS_BRIDGE ${GENERATED_DIR}/ui_events_bridge.generated.h)
set(GENERATED_UI_EVENTS_CLIENT ${GENERATED_DIR}/ui_events_client.generated.h)
set(GENERATED_UI_EVENTS_METADATA ${GENERATED_DIR}/api/private/ui_events_metadata.generated.h)
set(GENERATED_EX_CMDS_ENUM ${GENERATED_INCLUDES_DIR}/ex_cmds_enum.generated.h)
set(GENERATED_EX_CMDS_DEFS ${GENERATED_DIR}/ex_cmds_defs.generated.h)
set(GENERATED_FUNCS ${GENERATED_DIR}/funcs.generated.h)
set(GENERATED_KEYSETS ${GENERATED_DIR}/keysets.generated.h)
set(GENERATED_KEYSETS_DEFS ${GENERATED_DIR}/keysets_defs.generated.h)
set(GENERATED_EVENTS_ENUM ${GENERATED_INCLUDES_DIR}/auevents_enum.generated.h)
set(GENERATED_EVENTS_NAMES_MAP ${GENERATED_DIR}/auevents_name_map.generated.h)
set(GENERATED_OPTIONS ${GENERATED_DIR}/options.generated.h)
set(EX_CMDS_GENERATOR ${GENERATOR_DIR}/gen_ex_cmds.lua)
set(FUNCS_GENERATOR ${GENERATOR_DIR}/gen_eval.lua)
set(EVENTS_GENERATOR ${GENERATOR_DIR}/gen_events.lua)
set(KEYSETS_GENERATOR ${GENERATOR_DIR}/gen_keysets.lua)
set(OPTIONS_GENERATOR ${GENERATOR_DIR}/gen_options.lua)
set(UNICODE_TABLES_GENERATOR ${GENERATOR_DIR}/gen_unicode_tables.lua)
set(UNICODE_DIR ${PROJECT_SOURCE_DIR}/src/unicode)
set(GENERATED_UNICODE_TABLES ${GENERATED_DIR}/unicode_tables.generated.h)
set(VIM_MODULE_FILE ${GENERATED_DIR}/lua/vim_module.generated.h)
set(LUA_EDITOR_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/_editor.lua)
set(LUA_SHARED_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/shared.lua)
set(LUA_INSPECT_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/inspect.lua)
set(LUA_F_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/F.lua)
set(LUA_META_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/_meta.lua)
set(LUA_FILETYPE_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/filetype.lua)
set(LUA_INIT_PACKAGES_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/_init_packages.lua)
set(LUA_KEYMAP_MODULE_SOURCE ${PROJECT_SOURCE_DIR}/runtime/lua/vim/keymap.lua)
set(CHAR_BLOB_GENERATOR ${GENERATOR_DIR}/gen_char_blob.lua)
set(LINT_SUPPRESS_FILE ${PROJECT_BINARY_DIR}/errors.json)
set(LINT_SUPPRESS_URL_BASE "https://raw.githubusercontent.com/neovim/doc/gh-pages/reports/clint")
set(LINT_SUPPRESS_URL "${LINT_SUPPRESS_URL_BASE}/errors.json")
set(LINT_PRG ${PROJECT_SOURCE_DIR}/src/clint.py)
set(DOWNLOAD_SCRIPT ${PROJECT_SOURCE_DIR}/cmake/Download.cmake)
set(LINT_SUPPRESSES_ROOT ${PROJECT_BINARY_DIR}/errors)
set(LINT_SUPPRESSES_URL "${LINT_SUPPRESS_URL_BASE}/errors.tar.gz")
set(LINT_SUPPRESSES_ARCHIVE ${LINT_SUPPRESSES_ROOT}/errors.tar.gz)
set(LINT_SUPPRESSES_TOUCH_FILE "${TOUCHES_DIR}/unpacked-clint-errors-archive")
set(CLINT_REPORT_PATH ${LINT_SUPPRESSES_ROOT}/src/home/runner/work/doc/doc/gh-pages/reports/clint)

glob_wrapper(UNICODE_FILES ${UNICODE_DIR}/*.txt)
glob_wrapper(API_HEADERS api/*.h)
list(REMOVE_ITEM API_HEADERS ${CMAKE_CURRENT_LIST_DIR}/api/ui_events.in.h)
glob_wrapper(MSGPACK_RPC_HEADERS msgpack_rpc/*.h)

include_directories(${GENERATED_DIR})
include_directories(${CACHED_GENERATED_DIR})
include_directories(${GENERATED_INCLUDES_DIR})

file(MAKE_DIRECTORY ${TOUCHES_DIR})
file(MAKE_DIRECTORY ${GENERATED_DIR})
file(MAKE_DIRECTORY ${GENERATED_INCLUDES_DIR})
file(MAKE_DIRECTORY ${LINT_SUPPRESSES_ROOT})
file(MAKE_DIRECTORY ${LINT_SUPPRESSES_ROOT}/src)

glob_wrapper(NVIM_SOURCES *.c)
glob_wrapper(NVIM_HEADERS *.h)
glob_wrapper(EXTERNAL_SOURCES ../xdiff/*.c ../mpack/*.c ../cjson/*.c ../klib/*.c)
glob_wrapper(EXTERNAL_HEADERS ../xdiff/*.h ../mpack/*.h ../cjson/*.h ../klib/*.h)

foreach(subdir
        os
        api
        api/private
        msgpack_rpc
        tui
        event
        eval
        lua
        viml
        viml/parser
       )
  if(${subdir} MATCHES "tui" AND NOT FEAT_TUI)
    continue()
  endif()

  file(MAKE_DIRECTORY ${GENERATED_DIR}/${subdir})
  file(MAKE_DIRECTORY ${GENERATED_INCLUDES_DIR}/${subdir})
  glob_wrapper(sources ${subdir}/*.c)
  glob_wrapper(headers ${subdir}/*.h)
  list(APPEND NVIM_SOURCES ${sources})
  list(APPEND NVIM_HEADERS ${headers})
endforeach()

glob_wrapper(UNIT_TEST_FIXTURES ${PROJECT_SOURCE_DIR}/test/unit/fixtures/*.c)

# Sort file lists to ensure generated files are created in the same order from
# build to build.
list(SORT NVIM_SOURCES)
list(SORT NVIM_HEADERS)

list(APPEND LINT_NVIM_SOURCES ${NVIM_SOURCES} ${NVIM_HEADERS})

foreach(sfile ${NVIM_SOURCES})
  get_filename_component(f ${sfile} NAME)
  if(${f} MATCHES "^(regexp_nfa.c)$")
    list(APPEND to_remove ${sfile})
  endif()
  if(${f} MATCHES "^(regexp_bt.c)$")
    list(APPEND to_remove ${sfile})
  endif()
  if(WIN32 AND ${f} MATCHES "^(pty_process_unix.c)$")
    list(APPEND to_remove ${sfile})
  endif()
  if(NOT WIN32 AND ${f} MATCHES "^(pty_process_win.c)$")
    list(APPEND to_remove ${sfile})
  endif()
  if(NOT WIN32 AND ${f} MATCHES "^(pty_conpty_win.c)$")
    list(APPEND to_remove ${sfile})
  endif()
  if(NOT WIN32 AND ${f} MATCHES "^(os_win_console.c)$")
    list(APPEND to_remove ${sfile})
  endif()
endforeach()

list(REMOVE_ITEM NVIM_SOURCES ${to_remove})

if(NOT MSVC)
  # xdiff, mpack, lua-cjson: inlined external project, we don't maintain it. #9306
  set_source_files_properties(
    ${EXTERNAL_SOURCES} PROPERTIES COMPILE_FLAGS "${COMPILE_FLAGS} -Wno-conversion -Wno-missing-noreturn -Wno-missing-format-attribute -Wno-double-promotion -Wno-strict-prototypes")
endif()

if(NOT "${MIN_LOG_LEVEL}" MATCHES "^$")
  add_definitions(-DMIN_LOG_LEVEL=${MIN_LOG_LEVEL})
endif()

if(CLANG_ASAN_UBSAN OR CLANG_MSAN OR CLANG_TSAN)
  add_definitions(-DEXITFREE)
endif()

get_directory_property(gen_cdefs COMPILE_DEFINITIONS)
foreach(gen_cdef ${gen_cdefs} DO_NOT_DEFINE_EMPTY_ATTRIBUTES)
  if(NOT ${gen_cdef} MATCHES "INCLUDE_GENERATED_DECLARATIONS")
    list(APPEND gen_cflags "-D${gen_cdef}")
  endif()
endforeach()

get_directory_property(gen_includes INCLUDE_DIRECTORIES)
foreach(gen_include ${gen_includes} ${LUA_PREFERRED_INCLUDE_DIRS})
  list(APPEND gen_cflags "-I${gen_include}")
endforeach()
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin" AND CMAKE_OSX_SYSROOT)
  list(APPEND gen_cflags "-isysroot")
  list(APPEND gen_cflags "${CMAKE_OSX_SYSROOT}")
endif()
string(TOUPPER "${CMAKE_BUILD_TYPE}" build_type)
separate_arguments(C_FLAGS_ARRAY UNIX_COMMAND ${CMAKE_C_FLAGS})
separate_arguments(C_FLAGS_${build_type}_ARRAY UNIX_COMMAND ${CMAKE_C_FLAGS_${build_type}})
set(gen_cflags ${gen_cflags} ${C_FLAGS_${build_type}_ARRAY} ${C_FLAGS_ARRAY})

function(get_preproc_output varname iname)
  if(MSVC)
    set(${varname} /P /Fi${iname} /nologo PARENT_SCOPE)
  else()
    set(${varname} -E -o ${iname} PARENT_SCOPE)
  endif()
endfunction()

set(NVIM_VERSION_GIT_H ${PROJECT_BINARY_DIR}/cmake.config/auto/versiondef_git.h)
add_custom_target(update_version_stamp
  COMMAND ${CMAKE_COMMAND}
    -DNVIM_VERSION_MAJOR=${NVIM_VERSION_MAJOR}
    -DNVIM_VERSION_MINOR=${NVIM_VERSION_MINOR}
    -DNVIM_VERSION_PATCH=${NVIM_VERSION_PATCH}
    -DNVIM_VERSION_PRERELEASE=${NVIM_VERSION_PRERELEASE}
    -DOUTPUT=${NVIM_VERSION_GIT_H}
    -P ${PROJECT_SOURCE_DIR}/cmake/GenerateVersion.cmake
  BYPRODUCTS ${NVIM_VERSION_GIT_H})

# NVIM_GENERATED_FOR_HEADERS: generated headers to be included in headers
# NVIM_GENERATED_FOR_SOURCES: generated headers to be included in sources
# NVIM_GENERATED_SOURCES: generated source files
# These lists must be mutually exclusive.
foreach(sfile ${NVIM_SOURCES}
              "${CMAKE_CURRENT_LIST_DIR}/regexp_bt.c"
              "${CMAKE_CURRENT_LIST_DIR}/regexp_nfa.c"
              ${GENERATED_API_DISPATCH}
              "${GENERATED_UI_EVENTS_CALL}"
              "${GENERATED_UI_EVENTS_REMOTE}"
              "${GENERATED_UI_EVENTS_BRIDGE}"
              "${GENERATED_KEYSETS}"
              "${GENERATED_UI_EVENTS_CLIENT}"
              )
  get_filename_component(full_d ${sfile} DIRECTORY)
  file(RELATIVE_PATH d "${CMAKE_CURRENT_LIST_DIR}" "${full_d}")
  if(${d} MATCHES "^[.][.]|auto/")
    file(RELATIVE_PATH d "${GENERATED_DIR}" "${full_d}")
  endif()
  get_filename_component(f ${sfile} NAME)
  get_filename_component(r ${sfile} NAME_WE)
  if(NOT ${d} EQUAL ".")
    set(f "${d}/${f}")
    set(r "${d}/${r}")
  endif()
  set(gf_c_h "${GENERATED_DIR}/${r}.c.generated.h")
  set(gf_h_h "${GENERATED_INCLUDES_DIR}/${r}.h.generated.h")
  set(gf_i "${GENERATED_DIR}/${r}.i")

  get_preproc_output(PREPROC_OUTPUT ${gf_i})

  set(depends "${HEADER_GENERATOR}" "${sfile}")
  if("${f}" STREQUAL "version.c")
    # Ensure auto/versiondef_git.h exists after "make clean".
    list(APPEND depends update_version_stamp "${NVIM_VERSION_GIT_H}")
  endif()
  add_custom_command(
    OUTPUT "${gf_c_h}" "${gf_h_h}"
    COMMAND ${CMAKE_C_COMPILER} ${sfile} ${PREPROC_OUTPUT} ${gen_cflags}
    COMMAND "${LUA_PRG}" "${HEADER_GENERATOR}" "${sfile}" "${gf_c_h}" "${gf_h_h}" "${gf_i}"
    DEPENDS ${depends})
  list(APPEND NVIM_GENERATED_FOR_SOURCES "${gf_c_h}")
  list(APPEND NVIM_GENERATED_FOR_HEADERS "${gf_h_h}")
  if(${d} MATCHES "^api$" AND NOT ${f} MATCHES "^api/helpers.c$")
    list(APPEND API_HEADERS ${gf_h_h})
  endif()
endforeach()

add_custom_command(OUTPUT ${GENERATED_UNICODE_TABLES}
  COMMAND ${LUA_PRG} ${UNICODE_TABLES_GENERATOR}
                     ${UNICODE_DIR}
                     ${GENERATED_UNICODE_TABLES}
  DEPENDS
    ${UNICODE_TABLES_GENERATOR}
    ${UNICODE_FILES}
)

add_custom_command(
  OUTPUT ${GENERATED_API_DISPATCH} ${GENERATED_FUNCS_METADATA}
         ${API_METADATA} ${LUA_API_C_BINDINGS}
  COMMAND ${LUA_PRG} ${API_DISPATCH_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}
                     ${GENERATED_API_DISPATCH}
                     ${GENERATED_FUNCS_METADATA} ${API_METADATA}
                     ${LUA_API_C_BINDINGS}
                     ${API_HEADERS}
  DEPENDS
    ${API_HEADERS}
    ${MSGPACK_RPC_HEADERS}
    ${API_DISPATCH_GENERATOR}
    ${GENERATOR_C_GRAMMAR}
    ${CMAKE_CURRENT_LIST_DIR}/api/dispatch_deprecated.lua
)

add_custom_command(
  OUTPUT ${VIM_MODULE_FILE}
  COMMAND ${CMAKE_COMMAND} -E env
      "LUAC_PRG=${LUAC_PRG}"
      ${LUA_PRG} ${CHAR_BLOB_GENERATOR} -c ${VIM_MODULE_FILE}
      ${LUA_INIT_PACKAGES_MODULE_SOURCE} "vim._init_packages"
      ${LUA_INSPECT_MODULE_SOURCE} "vim.inspect"
      ${LUA_EDITOR_MODULE_SOURCE} "vim._editor"
      ${LUA_SHARED_MODULE_SOURCE} "vim.shared"
      ${LUA_F_MODULE_SOURCE} "vim.F"
      ${LUA_META_MODULE_SOURCE} "vim._meta"
      ${LUA_FILETYPE_MODULE_SOURCE} "vim.filetype"
      ${LUA_KEYMAP_MODULE_SOURCE} "vim.keymap"
  DEPENDS
    ${CHAR_BLOB_GENERATOR}
    ${LUA_INIT_PACKAGES_MODULE_SOURCE}
    ${LUA_EDITOR_MODULE_SOURCE}
    ${LUA_SHARED_MODULE_SOURCE}
    ${LUA_INSPECT_MODULE_SOURCE}
    ${LUA_F_MODULE_SOURCE}
    ${LUA_META_MODULE_SOURCE}
    ${LUA_FILETYPE_MODULE_SOURCE}
    ${LUA_LOAD_PACKAGE_MODULE_SOURCE}
    ${LUA_KEYMAP_MODULE_SOURCE}
  VERBATIM
)

list(APPEND NVIM_GENERATED_SOURCES
  "${LUA_API_C_BINDINGS}"
)

add_custom_command(
  OUTPUT ${GENERATED_UI_EVENTS}
         ${GENERATED_UI_EVENTS_CALL}
         ${GENERATED_UI_EVENTS_REMOTE}
         ${GENERATED_UI_EVENTS_BRIDGE}
         ${GENERATED_UI_EVENTS_METADATA}
         ${GENERATED_UI_EVENTS_CLIENT}
  COMMAND ${LUA_PRG} ${API_UI_EVENTS_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}
                     ${CMAKE_CURRENT_LIST_DIR}/api/ui_events.in.h
                     ${GENERATED_UI_EVENTS}
                     ${GENERATED_UI_EVENTS_CALL}
                     ${GENERATED_UI_EVENTS_REMOTE}
                     ${GENERATED_UI_EVENTS_BRIDGE}
                     ${GENERATED_UI_EVENTS_METADATA}
                     ${GENERATED_UI_EVENTS_CLIENT}
  DEPENDS
    ${API_UI_EVENTS_GENERATOR}
    ${GENERATOR_C_GRAMMAR}
    ${CMAKE_CURRENT_LIST_DIR}/api/ui_events.in.h
)

list(APPEND NVIM_GENERATED_FOR_HEADERS
  "${GENERATED_EX_CMDS_ENUM}"
  "${GENERATED_EVENTS_ENUM}"
  "${GENERATED_KEYSETS_DEFS}"
)

list(APPEND NVIM_GENERATED_FOR_SOURCES
  "${GENERATED_API_DISPATCH}"
  "${GENERATED_EX_CMDS_DEFS}"
  "${GENERATED_EVENTS_NAMES_MAP}"
  "${GENERATED_KEYSETS}"
  "${GENERATED_OPTIONS}"
  "${GENERATED_UNICODE_TABLES}"
  "${VIM_MODULE_FILE}"
)

list(APPEND NVIM_GENERATED_SOURCES
  "${PROJECT_BINARY_DIR}/cmake.config/auto/pathdef.c"
)

add_custom_command(OUTPUT ${GENERATED_EX_CMDS_ENUM} ${GENERATED_EX_CMDS_DEFS}
  COMMAND ${LUA_PRG} ${EX_CMDS_GENERATOR}
      ${CMAKE_CURRENT_LIST_DIR} ${GENERATED_INCLUDES_DIR} ${GENERATED_DIR}
  DEPENDS ${EX_CMDS_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}/ex_cmds.lua
)

add_custom_command(OUTPUT ${GENERATED_FUNCS} ${FUNCS_DATA}
  COMMAND ${LUA_PRG} ${FUNCS_GENERATOR}
      ${CMAKE_CURRENT_LIST_DIR} ${LUA_SHARED_MODULE_SOURCE} ${GENERATED_DIR} ${API_METADATA} ${FUNCS_DATA}
  DEPENDS ${FUNCS_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}/eval.lua ${API_METADATA}
)
list(APPEND NVIM_GENERATED_FOR_SOURCES
  "${GENERATED_FUNCS}")

add_custom_command(OUTPUT ${GENERATED_EVENTS_ENUM} ${GENERATED_EVENTS_NAMES_MAP}
  COMMAND ${LUA_PRG} ${EVENTS_GENERATOR}
      ${CMAKE_CURRENT_LIST_DIR} ${GENERATED_EVENTS_ENUM} ${GENERATED_EVENTS_NAMES_MAP}
  DEPENDS ${EVENTS_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}/auevents.lua
)

add_custom_command(OUTPUT ${GENERATED_KEYSETS} ${GENERATED_KEYSETS_DEFS}
  COMMAND ${LUA_PRG} ${KEYSETS_GENERATOR}
      ${CMAKE_CURRENT_LIST_DIR} ${LUA_SHARED_MODULE_SOURCE} ${GENERATED_KEYSETS} ${GENERATED_KEYSETS_DEFS}
  DEPENDS ${KEYSETS_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}/api/keysets.lua ${GENERATOR_HASHY}
)

add_custom_command(OUTPUT ${GENERATED_OPTIONS}
  COMMAND ${LUA_PRG} ${OPTIONS_GENERATOR}
                     ${CMAKE_CURRENT_LIST_DIR} ${GENERATED_OPTIONS}
  DEPENDS ${OPTIONS_GENERATOR} ${CMAKE_CURRENT_LIST_DIR}/options.lua
)

# NVIM_GENERATED_FOR_SOURCES and NVIM_GENERATED_FOR_HEADERS must be mutually exclusive.
foreach(hfile ${NVIM_GENERATED_FOR_HEADERS})
  list(FIND NVIM_GENERATED_FOR_SOURCES ${hfile} hfile_idx)
  if(NOT ${hfile_idx} EQUAL -1)
    message(FATAL_ERROR "File included in both NVIM_GENERATED_FOR_HEADERS and NVIM_GENERATED_FOR_SOURCES")
  endif()
endforeach()

# Our dependencies come first.

if (CMAKE_SYSTEM_NAME MATCHES "OpenBSD")
  list(APPEND NVIM_LINK_LIBRARIES pthread c++abi)
endif()

if (LibIntl_FOUND)
  list(APPEND NVIM_LINK_LIBRARIES ${LibIntl_LIBRARY})
endif()

if(Iconv_LIBRARIES)
  list(APPEND NVIM_LINK_LIBRARIES ${Iconv_LIBRARIES})
endif()

if(WIN32)
  list(APPEND NVIM_LINK_LIBRARIES netapi32)
endif()

# Use "luv" as imported library, to work around CMake using "-lluv" for
# "luv.so".  #10407
add_library(luv UNKNOWN IMPORTED)
set_property(TARGET luv PROPERTY IMPORTED_LOCATION ${LIBLUV_LIBRARIES})

# Put these last on the link line, since multiple things may depend on them.
list(APPEND NVIM_LINK_LIBRARIES
  luv
  ${LIBUV_LIBRARIES}
  ${MSGPACK_LIBRARIES}
  ${LIBVTERM_LIBRARIES}
  ${LIBTERMKEY_LIBRARIES}
  ${UNIBILIUM_LIBRARIES}
  ${UTF8PROC_LIBRARIES}
  ${TreeSitter_LIBRARIES}
  ${CMAKE_THREAD_LIBS_INIT}
)

if(UNIX)
  list(APPEND NVIM_LINK_LIBRARIES
    m)
  if (NOT CMAKE_SYSTEM_NAME STREQUAL "SunOS")
    list(APPEND NVIM_LINK_LIBRARIES
      util)
  endif()
endif()

set(NVIM_EXEC_LINK_LIBRARIES ${NVIM_LINK_LIBRARIES} ${LUA_PREFERRED_LIBRARIES})

add_executable(nvim ${NVIM_GENERATED_FOR_SOURCES} ${NVIM_GENERATED_FOR_HEADERS}
  ${NVIM_GENERATED_SOURCES} ${NVIM_SOURCES} ${NVIM_HEADERS}
  ${EXTERNAL_SOURCES} ${EXTERNAL_HEADERS})

set_target_properties(nvim
  PROPERTIES
  EXPORT_COMPILE_COMMANDS ON)

if(${CMAKE_VERSION} VERSION_LESS 3.20)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
endif()

target_link_libraries(nvim ${NVIM_EXEC_LINK_LIBRARIES})
install_helper(TARGETS nvim)
if(MSVC)
  install(FILES $<TARGET_PDB_FILE:nvim> DESTINATION ${CMAKE_INSTALL_BINDIR} OPTIONAL)
endif()

set_property(TARGET nvim APPEND PROPERTY
             INCLUDE_DIRECTORIES ${LUA_PREFERRED_INCLUDE_DIRS})
set_property(TARGET nvim PROPERTY ENABLE_EXPORTS TRUE)

if(ENABLE_LTO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT IPO_SUPPORTED)
  if(IPO_SUPPORTED AND (NOT CMAKE_BUILD_TYPE MATCHES Debug))
    set_property(TARGET nvim PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
  endif()
endif()

if(WIN32)
  # Copy DLLs and third-party tools to bin/ and install them along with nvim
  add_custom_target(nvim_runtime_deps ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_BINARY_DIR}/windows_runtime_deps/
      ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
  install(DIRECTORY ${PROJECT_BINARY_DIR}/windows_runtime_deps/
    DESTINATION ${CMAKE_INSTALL_BINDIR})

  add_custom_target(nvim_dll_deps DEPENDS nvim
    COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/windows_runtime_deps
    COMMAND ${CMAKE_COMMAND}
      "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
      -DBINARY="${PROJECT_BINARY_DIR}/bin/nvim${CMAKE_EXECUTABLE_SUFFIX}"
      -DDST=${PROJECT_BINARY_DIR}/windows_runtime_deps
      -P ${PROJECT_SOURCE_DIR}/cmake/WindowsDllCopy.cmake)
  add_dependencies(nvim_runtime_deps nvim_dll_deps)

  # A CMake script is used for copying the files to avoid the
  # "command line is too long" error that occurs when Ninja tries running
  # a command that exceeds the length limit (8191 characters) on Windows.
  # See https://developercommunity.visualstudio.com/content/problem/212207/file-open-cmake-the-command-line-is-too-long.html
  set(EXTERNAL_BLOBS_SCRIPT
    "file(MAKE_DIRECTORY \"${PROJECT_BINARY_DIR}/windows_runtime_deps/platforms\")")
  foreach(DEP_FILE IN ITEMS
                      curl-ca-bundle.crt
                      curl.exe
                      diff.exe
                      tee.exe
                      win32yank.exe
                      xxd.exe

                      # Dependencies for neovim-qt
                      bearer/qgenericbearer.dll
                      iconengines/qsvgicon.dll
                      imageformats/qgif.dll
                      imageformats/qicns.dll
                      imageformats/qico.dll
                      imageformats/qjpeg.dll
                      imageformats/qsvg.dll
                      imageformats/qtga.dll
                      imageformats/qtiff.dll
                      imageformats/qwbmp.dll
                      imageformats/qwebp.dll
                      platforms/qwindows.dll
                      styles/qwindowsvistastyle.dll
                      translations/qt_ar.qm
                      translations/qt_bg.qm
                      translations/qt_ca.qm
                      translations/qt_cs.qm
                      translations/qt_da.qm
                      translations/qt_de.qm
                      translations/qt_en.qm
                      translations/qt_es.qm
                      translations/qt_fi.qm
                      translations/qt_fr.qm
                      translations/qt_gd.qm
                      translations/qt_he.qm
                      translations/qt_hu.qm
                      translations/qt_it.qm
                      translations/qt_ja.qm
                      translations/qt_ko.qm
                      translations/qt_lv.qm
                      translations/qt_pl.qm
                      translations/qt_ru.qm
                      translations/qt_sk.qm
                      translations/qt_uk.qm
                      D3Dcompiler_47.dll
                      libEGL.dll
                      libgcc_s_seh-1.dll
                      libGLESv2.dll
                      libstdc++-6.dll
                      libwinpthread-1.dll
                      nvim-qt.exe
                      opengl32sw.dll
                      Qt5Core.dll
                      Qt5Gui.dll
                      Qt5Network.dll
                      Qt5Svg.dll
                      Qt5Widgets.dll

                      )
    get_filename_component(DEP_FILE_DIR ${DEP_FILE} DIRECTORY)
    set(EXTERNAL_BLOBS_SCRIPT "${EXTERNAL_BLOBS_SCRIPT}\n"
      "file(COPY \"${DEPS_PREFIX}/bin/${DEP_FILE}\"
         DESTINATION \"${PROJECT_BINARY_DIR}/windows_runtime_deps/${DEP_FILE_DIR}\")")
  endforeach()
  file(WRITE ${PROJECT_BINARY_DIR}/external_blobs.cmake ${EXTERNAL_BLOBS_SCRIPT})
  add_custom_target(external_blobs
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/external_blobs.cmake)
  set_target_properties(external_blobs PROPERTIES FOLDER deps)
  add_dependencies(nvim_runtime_deps external_blobs)
else()
  add_custom_target(nvim_runtime_deps)  # Stub target to avoid CMP0046.
endif()
set_target_properties(nvim_runtime_deps PROPERTIES FOLDER deps)

file(MAKE_DIRECTORY ${BINARY_LIB_DIR})

# install treesitter parser if bundled
if(EXISTS ${DEPS_PREFIX}/lib/nvim/parser)
  glob_wrapper(TREESITTER_PARSERS ${DEPS_PREFIX}/lib/nvim/parser/*)
  foreach(parser_lib ${TREESITTER_PARSERS})
    file(COPY ${parser_lib} DESTINATION ${BINARY_LIB_DIR}/parser)
  endforeach()
endif()

install(DIRECTORY ${BINARY_LIB_DIR}
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/nvim/
  USE_SOURCE_PERMISSIONS)

add_library(
  libnvim
  STATIC
  EXCLUDE_FROM_ALL
  ${NVIM_SOURCES} ${NVIM_GENERATED_SOURCES}
  ${NVIM_HEADERS} ${NVIM_GENERATED_FOR_SOURCES} ${NVIM_GENERATED_FOR_HEADERS}
  ${EXTERNAL_SOURCES} ${EXTERNAL_HEADERS}
)
set_property(TARGET libnvim APPEND PROPERTY
             INCLUDE_DIRECTORIES ${LUA_PREFERRED_INCLUDE_DIRS})
if(MSVC)
  set(LIBNVIM_NAME libnvim)
else()
  set(LIBNVIM_NAME nvim)
endif()
set_target_properties(
  libnvim
  PROPERTIES
    POSITION_INDEPENDENT_CODE ON
    OUTPUT_NAME ${LIBNVIM_NAME}
)
target_compile_options(libnvim PRIVATE -DMAKE_LIB)

if(NOT LUAJIT_FOUND)
  message(STATUS "luajit not found, skipping nvim-test (unit tests) target")
else()
  set(NVIM_TEST_LINK_LIBRARIES ${NVIM_LINK_LIBRARIES} ${LUAJIT_LIBRARIES})
  add_library(
    nvim-test
    MODULE
    EXCLUDE_FROM_ALL
    ${NVIM_SOURCES} ${NVIM_GENERATED_SOURCES}
    ${NVIM_HEADERS} ${NVIM_GENERATED_FOR_SOURCES} ${NVIM_GENERATED_FOR_HEADERS}
    ${EXTERNAL_SOURCES} ${EXTERNAL_HEADERS}
    ${UNIT_TEST_FIXTURES}
  )
  target_link_libraries(nvim-test ${NVIM_TEST_LINK_LIBRARIES})
  target_link_libraries(libnvim ${NVIM_TEST_LINK_LIBRARIES})
  set_property(
    TARGET nvim-test
    APPEND PROPERTY INCLUDE_DIRECTORIES ${LUAJIT_INCLUDE_DIRS}
  )
  set_target_properties(
    nvim-test
    PROPERTIES
      POSITION_INDEPENDENT_CODE ON
  )
  target_compile_options(nvim-test PRIVATE -DUNIT_TESTING)
endif()

if(CLANG_ASAN_UBSAN)
  message(STATUS "Enabling Clang address sanitizer and undefined behavior sanitizer for nvim.")
  check_c_compiler_flag(-fno-sanitize-recover=all SANITIZE_RECOVER_ALL)
  if(SANITIZE_RECOVER_ALL)
    if(CI_BUILD)
      # Try to recover from all sanitize issues so we get reports about all failures
      set(SANITIZE_RECOVER -fsanitize-recover=all)     # Clang 3.6+
    else()
      set(SANITIZE_RECOVER -fno-sanitize-recover=all)  # Clang 3.6+
    endif()
  else()
    if(CI_BUILD)
      # Try to recover from all sanitize issues so we get reports about all failures
      set(SANITIZE_RECOVER -fsanitize-recover)         # Clang 3.5-
    else()
      set(SANITIZE_RECOVER -fno-sanitize-recover)      # Clang 3.5-
    endif()
  endif()
  set_property(TARGET nvim APPEND PROPERTY COMPILE_OPTIONS ${SANITIZE_RECOVER} -fno-omit-frame-pointer -fno-optimize-sibling-calls -fsanitize=address -fsanitize=undefined -fsanitize-blacklist=${PROJECT_SOURCE_DIR}/src/.asan-blacklist)
  set_property(TARGET nvim APPEND_STRING PROPERTY LINK_FLAGS "-fsanitize=address -fsanitize=undefined ")
elseif(CLANG_MSAN)
  message(STATUS "Enabling Clang memory sanitizer for nvim.")
  set_property(TARGET nvim APPEND PROPERTY COMPILE_OPTIONS -fsanitize=memory -fsanitize-memory-track-origins -fno-omit-frame-pointer -fno-optimize-sibling-calls)
  set_property(TARGET nvim APPEND_STRING PROPERTY LINK_FLAGS "-fsanitize=memory -fsanitize-memory-track-origins ")
elseif(CLANG_TSAN)
  message(STATUS "Enabling Clang thread sanitizer for nvim.")
  set_property(TARGET nvim APPEND PROPERTY COMPILE_OPTIONS -fsanitize=thread)
  set_property(TARGET nvim APPEND PROPERTY COMPILE_OPTIONS -fPIE)
  set_property(TARGET nvim APPEND_STRING PROPERTY LINK_FLAGS "-fsanitize=thread ")
endif()

function(get_test_target prefix sfile relative_path_var target_var)
  get_filename_component(full_d "${sfile}" DIRECTORY)
  file(RELATIVE_PATH d "${PROJECT_SOURCE_DIR}/src/nvim" "${full_d}")
  if(d MATCHES "^[.][.]")
    file(RELATIVE_PATH d "${GENERATED_DIR}" "${full_d}")
  endif()
  get_filename_component(r "${sfile}" NAME)
  if(NOT d MATCHES "^[.]?$")
    set(r "${d}/${r}")
  endif()
  string(REGEX REPLACE "[/.]" "-" suffix "${r}")
  set(${relative_path_var} ${r} PARENT_SCOPE)
  if(prefix STREQUAL "")
    set(${target_var} "${suffix}" PARENT_SCOPE)
  else()
    set(${target_var} "${prefix}-${suffix}" PARENT_SCOPE)
  endif()
endfunction()

if(WIN32)
  set(NO_SINGLE_CHECK_HEADERS
    os/pty_process_unix.h
    os/unix_defs.h)
else()
  set(NO_SINGLE_CHECK_HEADERS
    os/win_defs.h
    os/pty_process_win.h
    os/pty_conpty_win.h
    os/os_win_console.h)
endif()
foreach(hfile ${NVIM_HEADERS})
  get_test_target(test-includes "${hfile}" relative_path texe)

  if(NOT ${hfile} MATCHES "[.](c|in)[.]h$")
    set(tsource "${GENERATED_DIR}/${relative_path}.test-include.c")
    write_file("${tsource}" "#include \"${hfile}\"\nint main(int argc, char **argv) { return 0; }")
    add_executable(
      ${texe}
      EXCLUDE_FROM_ALL
      ${tsource} ${NVIM_HEADERS} ${NVIM_GENERATED_FOR_HEADERS})
    set_property(
      TARGET ${texe}
      APPEND PROPERTY INCLUDE_DIRECTORIES ${LUA_PREFERRED_INCLUDE_DIRS}
    )
    set_target_properties(${texe} PROPERTIES FOLDER test)

    list(FIND NO_SINGLE_CHECK_HEADERS "${relative_path}" hfile_exclude_idx)
    if(${hfile_exclude_idx} EQUAL -1)
      list(APPEND HEADER_CHECK_TARGETS ${texe})
    endif()
  endif()
endforeach()
add_custom_target(check-single-includes DEPENDS ${HEADER_CHECK_TARGETS})

function(add_download output url allow_failure)
  add_custom_command(
    OUTPUT "${output}"
    COMMAND
      ${CMAKE_COMMAND}
        -DURL=${url} -DFILE=${output}
        -DALLOW_FAILURE=${allow_failure}
        -P ${DOWNLOAD_SCRIPT}
    DEPENDS ${DOWNLOAD_SCRIPT}
  )
endfunction()

add_download(${LINT_SUPPRESSES_ARCHIVE} ${LINT_SUPPRESSES_URL} off)

add_custom_command(
  OUTPUT ${LINT_SUPPRESSES_TOUCH_FILE}
  WORKING_DIRECTORY ${LINT_SUPPRESSES_ROOT}/src
  COMMAND ${CMAKE_COMMAND} -E tar xfz ${LINT_SUPPRESSES_ARCHIVE}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CLINT_REPORT_PATH} "${LINT_SUPPRESSES_ROOT}"
  COMMAND ${CMAKE_COMMAND} -E touch ${LINT_SUPPRESSES_TOUCH_FILE}
  DEPENDS ${LINT_SUPPRESSES_ARCHIVE}
)

add_download(${LINT_SUPPRESS_FILE} ${LINT_SUPPRESS_URL} off)

if(CI_BUILD)
  set(LINT_OUTPUT_FORMAT gh_action)
else()
  set(LINT_OUTPUT_FORMAT vs7)
endif()

set(LINT_NVIM_REL_SOURCES)
foreach(sfile ${LINT_NVIM_SOURCES})
  get_test_target("" "${sfile}" r suffix)
  set(suppress_file ${LINT_SUPPRESSES_ROOT}/${suffix}.json)
  set(suppress_url "${LINT_SUPPRESS_URL_BASE}/${suffix}.json")
  set(rsfile src/nvim/${r})
  set(touch_file "${TOUCHES_DIR}/ran-clint-${suffix}")
  add_custom_command(
    OUTPUT ${touch_file}
    COMMAND ${LINT_PRG} --suppress-errors=${suppress_file} --output=${LINT_OUTPUT_FORMAT} ${rsfile}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND ${CMAKE_COMMAND} -E touch ${touch_file}
    DEPENDS ${LINT_PRG} ${sfile} ${LINT_SUPPRESSES_TOUCH_FILE}
  )
  list(APPEND LINT_TARGETS ${touch_file})
  list(APPEND LINT_NVIM_REL_SOURCES ${rsfile})
endforeach()
add_custom_target(lintc DEPENDS ${LINT_TARGETS})

add_custom_target(uncrustify-version
  COMMAND ${CMAKE_COMMAND}
    -D UNCRUSTIFY_PRG=${UNCRUSTIFY_PRG}
    -D CONFIG_FILE=${PROJECT_SOURCE_DIR}/src/uncrustify.cfg
    -P ${PROJECT_SOURCE_DIR}/cmake/CheckUncrustifyVersion.cmake)

add_glob_target(
  TARGET lintuncrustify
  COMMAND ${UNCRUSTIFY_PRG}
  FLAGS -c "${PROJECT_SOURCE_DIR}/src/uncrustify.cfg" -q --check
  FILES ${LINT_NVIM_SOURCES}
  )
add_dependencies(lintuncrustify uncrustify-version)

add_custom_target(formatc
  COMMAND ${CMAKE_COMMAND}
    -D FORMAT_PRG=${UNCRUSTIFY_PRG}
    -D LANG=c
    -P ${PROJECT_SOURCE_DIR}/cmake/Format.cmake
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
add_dependencies(formatc uncrustify-version)

add_custom_target(
  lintcfull
  COMMAND
    ${LINT_PRG} --suppress-errors=${LINT_SUPPRESS_FILE} --output=${LINT_OUTPUT_FORMAT} ${LINT_NVIM_REL_SOURCES}
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  DEPENDS ${LINT_PRG} ${LINT_NVIM_SOURCES} ${LINT_SUPPRESS_FILE} lintuncrustify
)

add_custom_target(generated-sources DEPENDS
  ${NVIM_GENERATED_FOR_SOURCES}
  ${NVIM_GENERATED_FOR_HEADERS}
  ${NVIM_GENERATED_SOURCES}
)

add_subdirectory(po)

include(GetCompileFlags)
get_compile_flags(NVIM_VERSION_CFLAGS)
