cmake_minimum_required(VERSION 3.1)

project(d_ff_reset NONE)

file(GLOB SRCS *.vhd)
#file(COPY ${SRCS} in.txt  DESTINATION ${CMAKE_BINARY_DIR})
file(COPY in.txt  DESTINATION ${CMAKE_BINARY_DIR})

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
	sim ALL
	COMMAND fuse -intstyle ise -incremental -lib secureip -o ${PROJECT_NAME}_tb_isim.exe -prj ${PROJECT_NAME}_tb.prj work.${PROJECT_NAME}_tb
	COMMAND ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_tb_isim.exe -intstyle ise -gui -tclbatch isim.cmd
	COMMAND ${CMAKE_COMMAND} -E copy out.txt ${CMAKE_SOURCE_DIR}/out.txt
)
