cmake_minimum_required(VERSION 3.1)

project(eq2 NONE)

file(GLOB SRCS *.vhd)
set(UCF ${PROJECT_NAME}.ucf)
file(COPY ${SRCS} ${UCF} in.txt  DESTINATION ${CMAKE_BINARY_DIR})

execute_process(
	COMMAND xtclsh ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.tcl rebuild_project
)

add_custom_command(  
	COMMAND xtclsh ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.tcl run_process
	OUTPUT ${PROJECT_NAME}.bit
)

add_custom_target(generate-bit ALL
	DEPENDS ${PROJECT_NAME}.bit
)

file(WRITE ${CMAKE_BINARY_DIR}/download.cmd 
"setMode -bs
setCable -port auto
Identify -inferir
identifyMPM
assignFile -p 1 -file ${PROJECT_NAME}.bit
Program -p 1
exit")

add_custom_target(download-bit
	COMMAND impact -batch download.cmd
	DEPENDS generate-bit
)
set(SIZE 16384)
file(WRITE ${CMAKE_BINARY_DIR}/generate.cmd
"setMode -pff
addConfigDevice -name \"${PROJECT_NAME}\" -path \".\"
setSubmode -pffspi
setAttribute -configdevice -attr multibootBpiType -value \"\"
addDesign -version 0 -name \"0\"
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value \"FALSE\"
setAttribute -configdevice -attr autoSize -value \"FALSE\"
setAttribute -configdevice -attr fileFormat -value \"mcs\"
setAttribute -configdevice -attr fillValue -value \"FF\"
setAttribute -configdevice -attr swapBit -value \"FALSE\"
setAttribute -configdevice -attr dir -value \"UP\"
setAttribute -configdevice -attr multiboot -value \"FALSE\"
setAttribute -configdevice -attr spiSelected -value \"TRUE\"
addPromDevice -p 1 -size ${SIZE}
setAttribute -design -attr name -value \"0000\"
addDevice -p 1 -file \"${PROJECT_NAME}.bit\"
generate
quit")
set(FLASH_DEVICE N25Q128)
file(WRITE ${CMAKE_BINARY_DIR}/program.cmd 
"setMode -bscan
setCable -p auto
identify -inferir
identifyMPM
attachflash -position 1 -spi \"${FLASH_DEVICE}\"
assignfiletoattachedflash -position 1 -file ${PROJECT_NAME}.mcs
Program -p 1 -dataWidth 1 -spionly -e -loadfpga
quit")

add_custom_target(
	generate-mcs ALL
	COMMAND impact -batch generate.cmd
	DEPENDS generate-bit
)

install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.bit ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.mcs DESTINATION ${CMAKE_SOURCE_DIR})

add_custom_target(
	program-mcs
	COMMAND impact -batch program.cmd
	DEPENDS generate-mcs
)
file(WRITE ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_tb.prj "")
foreach(SRC ${SRCS})
file(APPEND ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_tb.prj
"vhdl work \"${SRC}\"
")
endforeach()
file(WRITE ${CMAKE_BINARY_DIR}/isim.cmd
"onerror {resume}
wave add /
run all;")
add_custom_target(
	sim
	COMMAND fuse -intstyle ise -incremental -lib secureip -o ${PROJECT_NAME}_tb_isim.exe -prj ${PROJECT_NAME}_tb.prj work.${PROJECT_NAME}_tb
	COMMAND ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_tb_isim.exe -intstyle ise -gui -tclbatch isim.cmd
	COMMAND ${CMAKE_COMMAND} -E copy out.txt ${CMAKE_SOURCE_DIR}/out.txt
)

set(ADD_CLEAN_FILES
	${PROJECT_NAME}.ngd ${PROJECT_NAME}.ut ${PROJECT_NAME}_ngdbuild.xrpt
	${PROJECT_NAME}.ngr ${PROJECT_NAME}.pad ${PROJECT_NAME}.xpi
	${PROJECT_NAME}_pad.csv ${PROJECT_NAME}.xst ${PROJECT_NAME}.bgn
	${PROJECT_NAME}_pad.txt ${PROJECT_NAME}_xst.xrpt ${PROJECT_NAME}_bitgen.xwbt
	${PROJECT_NAME}.par ${PROJECT_NAME}.bld ${PROJECT_NAME}_par.xrpt
	${PROJECT_NAME}.cfi ${PROJECT_NAME}.pcf ${PROJECT_NAME}.cmd_log
	${PROJECT_NAME}.prj ${PROJECT_NAME}.drc ${PROJECT_NAME}.prm
	${PROJECT_NAME}.ptwx ${PROJECT_NAME}_guide.ncd ${PROJECT_NAME}.stx
	${PROJECT_NAME}.lso ${PROJECT_NAME}_summary.xml ${PROJECT_NAME}_map.map
	${PROJECT_NAME}.syr ${PROJECT_NAME}_map.mrp ${PROJECT_NAME}_map.ncd
	${PROJECT_NAME}_map.ngm ${PROJECT_NAME}.twr ${PROJECT_NAME}_map.xrpt
	${PROJECT_NAME}.twx ${PROJECT_NAME}.mcs ${PROJECT_NAME}.ncd 
	${PROJECT_NAME}.unroutes ${PROJECT_NAME}.ngc ${PROJECT_NAME}_usage.xml
	_impactbatch.log _ngo par_usage_statistics.html usage_statistics_webtalk.html webtalk.log webtalk_pn.xml xlnx_auto_0_xdb xst)

# Add clean files
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${ADD_CLEAN_FILES}")
