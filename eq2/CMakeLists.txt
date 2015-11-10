cmake_minimum_required(VERSION 3.1)

project(eq2 NONE)

file(GLOB SRCS *.vhd)
set(UCF ${PROJECT_NAME}.ucf)
file(COPY ${SRCS} ${UCF} in.txt  DESTINATION ${CMAKE_BINARY_DIR})

add_custom_command(
	COMMAND xtclsh ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.tcl rebuild_project
	OUTPUT ${PROJECT_NAME}.bit
)

add_custom_target(build ALL
	COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_NAME}.bit ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.bit
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
	DEPENDS ${PROJECT_NAME}.bit
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
	generate-mcs
	COMMAND impact -batch generate.cmd
	COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_NAME}.mcs ${CMAKE_SOURCE_DIR}/${PROJECT_NAME}.mcs
	DEPENDS ${PROJECT_NAME}.bit
)

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
	COMMAND ./${PROJECT_NAME}_tb_isim.exe -intstyle ise -gui -tclbatch isim.cmd
	COMMAND ${CMAKE_COMMAND} -E copy out.txt ${CMAKE_SOURCE_DIR}/out.txt
)
