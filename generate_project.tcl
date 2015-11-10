project new "eq2"
project set family "Spartan6"
project set device "xc6slx9"
project set package "csg324"
project set speed "-2"
project set top_level_module_type "HDL"
project set synthesis_tool "XST (VHDL/Verilog)"
project set simulator "ISim (VHDL/Verilog)"
project set "Preferred Language" "VHDL"
project set "Enable Message Filtering" "false"

#xfile add "eq1.vhd"
#xfile add "eq2.vhd"
#xfile add "eq2.ucf"

#project set top "struc_arch" "eq2"

#project save
