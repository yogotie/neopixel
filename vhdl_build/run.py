
from pathlib import Path
from vunit import VUnit

SRC_PATH = Path(__file__).parent / "vhdl_src"
UUT_PATH = Path(__file__).parent / "vhdl_uut"

VU = VUnit.from_argv()

UUT = VU.add_library("uut")

UUT.add_source_files("../vhdl_src/*.vhd")
UUT.add_source_files("../vhdl_uut/*.vhd")

VU.main()

