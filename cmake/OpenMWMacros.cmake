function(enable_unity_build UB_SUFFIX SOURCE_VARIABLE_NAME)
    set(files ${SOURCE_VARIABLE_NAME})
    # Generate a unique filename for the unity build translation unit
    set(unit_build_file ${CMAKE_CURRENT_BINARY_DIR}/ub_${UB_SUFFIX}.cpp)
    # Exclude all translation units from compilation
    set_source_files_properties(${files} PROPERTIES HEADER_FILE_ONLY true)
    # Open the ub file
        FILE(WRITE ${unit_build_file} "// Unity Build generated by CMake\n")
    # Add include statement for each translation unit
    foreach(source_file ${files} )
        FILE( APPEND ${unit_build_file} "#include <${source_file}>\n")
    endforeach(source_file)
    # Complement list of translation units with the name of ub
    set(${SOURCE_VARIABLE_NAME} ${${SOURCE_VARIABLE_NAME}} ${unit_build_file} PARENT_SCOPE)
endfunction(enable_unity_build)



macro (add_openmw_dir dir)
    set (files)
    set (cppfiles)

    foreach (u ${ARGN})

        # Add cpp and hpp to OPENMW_FILES
        file (GLOB ALL "${dir}/${u}.[ch]pp")
        foreach (f ${ALL})
            list (APPEND files "${f}")
            list (APPEND OPENMW_FILES "${f}")
        endforeach (f)

        # Add cpp to unity build
        file (GLOB ALL "${dir}/${u}.cpp")
        foreach (f ${ALL})
            list (APPEND cppfiles "${f}")
        endforeach (f)

    endforeach (u)

    if (OPENMW_UNITY_BUILD)
        enable_unity_build(${newDir} "${cppfiles}")
        list (APPEND OPENMW_FILES ${CMAKE_CURRENT_BINARY_DIR}/ub_${newDir}.cpp)
    endif()

    string(REGEX REPLACE "/" "\\\\" newDir ${dir})
    source_group ("apps\\openmw\\${newDir}" FILES ${files})
endmacro (add_openmw_dir)

macro (add_component_dir dir)
    set (files)
    set (cppfiles)

    foreach (u ${ARGN})
        file (GLOB ALL "${dir}/${u}.[ch]pp")

        foreach (f ${ALL})
            list (APPEND files "${f}")
            list (APPEND COMPONENT_FILES "${f}")
        endforeach (f)

        # Add cpp to unity build
        file (GLOB ALL "${dir}/${u}.cpp")
        foreach (f ${ALL})
            list (APPEND cppfiles "${f}")
        endforeach (f)

    endforeach (u)

    if (OPENMW_UNITY_BUILD)
        enable_unity_build(${newDir} "${cppfiles}")
        list (APPEND COMPONENT_FILES ${CMAKE_CURRENT_BINARY_DIR}/ub_${newDir}.cpp)
    endif()

    string(REGEX REPLACE "/" "\\\\" newDir ${dir})
    source_group ("components\\${newDir}" FILES ${files})
endmacro (add_component_dir)

macro (add_component_qt_dir dir)
set (files)
foreach (u ${ARGN})
file (GLOB ALL "${dir}/${u}.[ch]pp")
foreach (f ${ALL})
list (APPEND files "${f}")
list (APPEND COMPONENT_FILES "${f}")
endforeach (f)
file (GLOB MOC_H "${dir}/${u}.hpp")
foreach (fi ${MOC_H})
list (APPEND COMPONENT_MOC_FILES "${fi}")
endforeach (fi)
endforeach (u)
source_group ("components\\${dir}" FILES ${files})
endmacro (add_component_qt_dir)

macro (add_file project type file)
list (APPEND ${project}${type} ${file})
endmacro (add_file)

macro (add_unit project dir unit)
add_file (${project} _HDR ${comp} "${dir}/${unit}.hpp")
add_file (${project} _SRC ${comp} "${dir}/${unit}.cpp")
endmacro (add_unit)

macro (add_qt_unit project dir unit)
add_file (${project} _HDR ${comp} "${dir}/${unit}.hpp")
add_file (${project} _HDR_QT ${comp} "${dir}/${unit}.hpp")
add_file (${project} _SRC ${comp} "${dir}/${unit}.cpp")
endmacro (add_qt_unit)

macro (add_hdr project dir unit)
add_file (${project} _HDR ${comp} "${dir}/${unit}.hpp")
endmacro (add_hdr)

macro (add_qt_hdr project dir unit)
add_file (${project} _HDR ${comp} "${dir}/${unit}.hpp")
add_file (${project} _HDR_QT ${comp} "${dir}/${unit}.hpp")
endmacro (add_qt_hdr)

macro (opencs_units dir)
foreach (u ${ARGN})
add_qt_unit (OPENCS ${dir} ${u})
endforeach (u)
endmacro (opencs_units)

macro (opencs_units_noqt dir)
foreach (u ${ARGN})
add_unit (OPENCS ${dir} ${u})
endforeach (u)
endmacro (opencs_units_noqt)

macro (opencs_hdrs dir)
foreach (u ${ARGN})
add_qt_hdr (OPENCS ${dir} ${u})
endforeach (u)
endmacro (opencs_hdrs)

macro (opencs_hdrs_noqt dir)
foreach (u ${ARGN})
add_hdr (OPENCS ${dir} ${u})
endforeach (u)
endmacro (opencs_hdrs_noqt)

include(CMakeParseArguments)

macro (openmw_add_executable target)
	set(OMW_ADD_EXE_OPTIONS WIN32 MACOSX_BUNDLE EXCLUDE_FROM_ALL)
	set(OMW_ADD_EXE_VALUES)
	set(OMW_ADD_EXE_MULTI_VALUES)
	cmake_parse_arguments(OMW_ADD_EXE "${OMW_ADD_EXE_OPTIONS}" "${OMW_ADD_EXE_VALUES}" "${OMW_ADD_EXE_MULTI_VALUES}" ${ARGN})
	
	if (OMW_ADD_EXE_WIN32)
		set(OMW_ADD_EXE_WIN32_VALUE WIN32)
	endif (OMW_ADD_EXE_WIN32)
	
	if (OMW_ADD_EXE_MACOSX_BUNDLE)
		set(OMW_ADD_EXE_MACOSX_BUNDLE_VALUE MACOSX_BUNDLE)
	endif (OMW_ADD_EXE_MACOSX_BUNDLE)
	
	if (OMW_ADD_EXE_EXCLUDE_FROM_ALL)
		set(OMW_ADD_EXE_EXCLUDE_FROM_ALL_VALUE EXCLUDE_FROM_ALL)
	endif (OMW_ADD_EXE_EXCLUDE_FROM_ALL)
	
	add_executable(${target} ${OMW_ADD_EXE_WIN32_VALUE} ${OMW_ADD_EXE_MACOSX_BUNDLE_VALUE} ${OMW_ADD_EXE_EXCLUDE_FROM_ALL_VALUE} ${OMW_ADD_EXE_UNPARSED_ARGUMENTS})
	
	if (MSVC)
		if (CMAKE_VERSION VERSION_GREATER 3.8 OR CMAKE_VERSION VERSION_EQUAL 3.8)
			set_target_properties(${target} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "$(TargetDir)")
		endif (CMAKE_VERSION VERSION_GREATER 3.8 OR CMAKE_VERSION VERSION_EQUAL 3.8)
	endif (MSVC)
endmacro (openmw_add_executable)

macro (get_generator_is_multi_config VALUE)
	if (DEFINED generator_is_multi_config_var)
		set(${VALUE} ${generator_is_multi_config_var})
	else (DEFINED generator_is_multi_config_var)
		if (CMAKE_VERSION VERSION_GREATER 3.9 OR CMAKE_VERSION VERSION_EQUAL 3.9)
			get_cmake_property(${VALUE} GENERATOR_IS_MULTI_CONFIG)
		else (CMAKE_VERSION VERSION_GREATER 3.9 OR CMAKE_VERSION VERSION_EQUAL 3.9)
			list(LENGTH CMAKE_CONFIGURATION_TYPES ${VALUE})
		endif (CMAKE_VERSION VERSION_GREATER 3.9 OR CMAKE_VERSION VERSION_EQUAL 3.9)
	endif (DEFINED generator_is_multi_config_var)
endmacro (get_generator_is_multi_config)

macro (copy_resource_file source_path destination_dir_base dest_path_relative)
	get_generator_is_multi_config(multi_config)
	if (multi_config)
		foreach(cfgtype ${CMAKE_CONFIGURATION_TYPES})
			configure_file(${source_path} "${destination_dir_base}/${cfgtype}/${dest_path_relative}" COPYONLY)
		endforeach(cfgtype)
	else (multi_config)
		configure_file(${source_path} "${destination_dir_base}/${dest_path_relative}" COPYONLY)
	endif (multi_config)
endmacro (copy_resource_file)

macro (configure_resource_file source_path destination_dir_base dest_path_relative)
	get_generator_is_multi_config(multi_config)
	if (multi_config)
		foreach(cfgtype ${CMAKE_CONFIGURATION_TYPES})
			configure_file(${source_path} "${destination_dir_base}/${cfgtype}/${dest_path_relative}")
		endforeach(cfgtype)
	else (multi_config)
		configure_file(${source_path} "${destination_dir_base}/${dest_path_relative}")
	endif (multi_config)
endmacro (configure_resource_file)

macro (copy_all_resource_files source_dir destination_dir_base destination_dir_relative files)
	foreach (f ${files})
		get_filename_component(filename ${f} NAME)
		copy_resource_file("${source_dir}/${f}" "${destination_dir_base}" "${destination_dir_relative}/${filename}")
	endforeach (f)
endmacro (copy_all_resource_files)
