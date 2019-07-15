macro (vhdl_add_sources)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        if (_relPath)
            list (APPEND VHDL_SOURCES "${CMAKE_SOURCE_DIR}/${_relPath}/${_src}")
            message("-- Adding VHDL Source: ${CMAKE_SOURCE_DIR}/${_relPath}/${_src}")
        else()
            list (APPEND VHDL_SOURCES "${CMAKE_SOURCE_DIR}/${_src}")
            message("-- Adding VHDL Source: ${CMAKE_SOURCE_DIR}/${_src}")
        endif()
    endforeach()

    if (_relPath)
        set (VHDL_SOURCES ${VHDL_SOURCES} PARENT_SCOPE)
    endif()
endmacro()

# Add source directory macro
macro (vhdl_add_subdirectory)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        add_subdirectory(${_src})
        # propagate SRCS to parent directory
        set (VHDL_SOURCES ${VHDL_SOURCES} PARENT_SCOPE)
    endforeach()
endmacro()

macro (vhdl_add_test)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (ENTITY_NAME ${ARGN})
        set(TEST_NAME "${ENTITY_NAME}")

        set(TRACE_PATH "${CMAKE_BINARY_DIR}/trace/")
        file(MAKE_DIRECTORY ${TRACE_PATH})
        set(TRACE_PATH "${TRACE_PATH}/${ENTITY_NAME}.vcd")

        add_custom_target("${ENTITY_NAME}" COMMAND ghdl -m --std=08 --workdir="${CMAKE_BINARY_DIR}" ${ENTITY_NAME} DEPENDS index)
        add_test(NAME "${ENTITY_NAME}" COMMAND ghdl -r --workdir="${CMAKE_BINARY_DIR}" "${ENTITY_NAME}" --vcd=${TRACE_PATH})

        add_dependencies(check "${ENTITY_NAME}")

        message("-- Adding VHDL Test: ${CMAKE_SOURCE_DIR}/${ENTITY_NAME}")
    endforeach()
endmacro()

