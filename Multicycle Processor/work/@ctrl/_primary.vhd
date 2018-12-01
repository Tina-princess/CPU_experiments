library verilog;
use verilog.vl_types.all;
entity Ctrl is
    generic(
        sif             : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        sid             : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        exe1            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        exe2            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        exe3            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        exe4            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1);
        exe5            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        exe6            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1);
        exe7            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        exe8            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1);
        exe9            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0);
        exe10           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1);
        exe11           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0);
        exe12           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1);
        exe13           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0);
        exe14           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1);
        exe15           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        exe16           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1);
        exe17           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0);
        exe18           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1);
        exe19           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0);
        exe20           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1);
        mem1            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0);
        mem2            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1);
        mem3            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0);
        mem4            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1);
        mem5            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0);
        mem6            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1);
        mem7            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0);
        mem8            : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi1);
        wb1             : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0);
        wb2             : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1);
        wb3             : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        opcode_i        : in     vl_logic_vector(5 downto 0);
        rt_i            : in     vl_logic_vector(4 downto 0);
        funct_i         : in     vl_logic_vector(5 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        PCWrite_o       : out    vl_logic;
        PCWriteCond_o   : out    vl_logic;
        IorD_o          : out    vl_logic;
        MemRead_o       : out    vl_logic;
        MemWrite_o      : out    vl_logic;
        MemtoReg_o      : out    vl_logic_vector(2 downto 0);
        IRWrite_o       : out    vl_logic;
        RegDst_o        : out    vl_logic_vector(1 downto 0);
        RegWrite_o      : out    vl_logic;
        ALUSrcA_o       : out    vl_logic_vector(1 downto 0);
        ALUSrcB_o       : out    vl_logic_vector(2 downto 0);
        ALUOp_o         : out    vl_logic_vector(2 downto 0);
        PCSource_o      : out    vl_logic_vector(1 downto 0);
        EXTOp_o         : out    vl_logic_vector(1 downto 0);
        Branch_o        : out    vl_logic_vector(2 downto 0);
        BEOp_o          : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of sif : constant is 2;
    attribute mti_svvh_generic_type of sid : constant is 2;
    attribute mti_svvh_generic_type of exe1 : constant is 2;
    attribute mti_svvh_generic_type of exe2 : constant is 2;
    attribute mti_svvh_generic_type of exe3 : constant is 2;
    attribute mti_svvh_generic_type of exe4 : constant is 2;
    attribute mti_svvh_generic_type of exe5 : constant is 2;
    attribute mti_svvh_generic_type of exe6 : constant is 2;
    attribute mti_svvh_generic_type of exe7 : constant is 2;
    attribute mti_svvh_generic_type of exe8 : constant is 2;
    attribute mti_svvh_generic_type of exe9 : constant is 2;
    attribute mti_svvh_generic_type of exe10 : constant is 2;
    attribute mti_svvh_generic_type of exe11 : constant is 2;
    attribute mti_svvh_generic_type of exe12 : constant is 2;
    attribute mti_svvh_generic_type of exe13 : constant is 2;
    attribute mti_svvh_generic_type of exe14 : constant is 2;
    attribute mti_svvh_generic_type of exe15 : constant is 2;
    attribute mti_svvh_generic_type of exe16 : constant is 2;
    attribute mti_svvh_generic_type of exe17 : constant is 2;
    attribute mti_svvh_generic_type of exe18 : constant is 2;
    attribute mti_svvh_generic_type of exe19 : constant is 2;
    attribute mti_svvh_generic_type of exe20 : constant is 2;
    attribute mti_svvh_generic_type of mem1 : constant is 2;
    attribute mti_svvh_generic_type of mem2 : constant is 2;
    attribute mti_svvh_generic_type of mem3 : constant is 2;
    attribute mti_svvh_generic_type of mem4 : constant is 2;
    attribute mti_svvh_generic_type of mem5 : constant is 2;
    attribute mti_svvh_generic_type of mem6 : constant is 2;
    attribute mti_svvh_generic_type of mem7 : constant is 2;
    attribute mti_svvh_generic_type of mem8 : constant is 2;
    attribute mti_svvh_generic_type of wb1 : constant is 2;
    attribute mti_svvh_generic_type of wb2 : constant is 2;
    attribute mti_svvh_generic_type of wb3 : constant is 2;
end Ctrl;