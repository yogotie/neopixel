
from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()

UUT = VU.add_library("uut")

UUT.add_source_files("../vhdl_src/*.vhd")
UUT.add_source_files("../vhdl_uut/*.vhd")

VU.main()

