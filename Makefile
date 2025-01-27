

#--------------------------------------------------
# Important sub directories 

CIL := cil
CIL_OBJS := $(CIL)/obj/x86_LINUX
CIL_INCLUDE := -I $(CIL_OBJS)
DS_DIR := datastructs
PTA_DIR := pta
FP_DIR := fp_analysis
FP_RCI_DIR := fp_rci_analysis
RADAR_DIR := radar
VPATH = $(DS_DIR) $(PTA_DIR) $(FP_DIR) $(FP_RCI_DIR) $(RADAR_DIR)


#--------------------------------------------------
# Compiler consts

OCAMLC := $(shell if ocamlc.opt > /dev/null 2>&1; then echo 'ocamlc.opt'; else echo 'ocamlc'; fi)
OCAMLOPT := $(shell if ocamlopt.opt > /dev/null 2>&1; then echo 'ocamlopt.opt'; else echo 'ocamlopt'; fi)
OCAMLDEP := $(shell if ocamldep.opt > /dev/null 2>&1; then echo 'ocamldep.opt'; else echo 'ocamldep'; fi)
OCAMLDOC := $(shell if ocamldoc.opt > /dev/null 2>&1; then echo 'ocamldoc.opt'; else echo 'ocamldoc'; fi)

SUB_INCLUDES=$(addprefix -I , $(VPATH))

INCLUDES := $(CIL_INCLUDE) $(SUB_INCLUDES)
TO_LINK := -ccopt -L$(CIL_OBJS) 
OCAMLFLAGS := -thread $(INCLUDES) -g $(TO_LINK) \
	unix.cma str.cma threads.cma statfs_c.o
OCAMLOPTFLAGS := -thread $(INCLUDES) -dtypes $(TO_LINK) \
	unix.cmxa str.cmxa threads.cmxa statfs_c.o -g 
# add a -p to enable profiling for gprof

OPT_EXT:=.exe
BYTE_EXT:=.byte

#--------------------------------------------------
# Objs/targets

UTILS := gen_num strutil logging stdutil statfs mystats gc_stats \
	config gz_marshal scp inspect timeout size osize

CIL_EXTRAS := exit_funcs pp_visitor scope cilinfos cil_lvals offset \
	type_reach type_utils cast_hierarchy

DATA_STRUCTS := queueset stackset mapset prioqueuemap iset uf \
	intrange hashcons \
	simplehc distributions list_utils graph sparsebitv scc 

PTA := pta_types pta_compile pta_shared pta_cycle pta_offline_cycle \
	pta_fp_test pta_fi_eq pta_fb_eq pta_fs_dir 

BACKING_STORE := backed_summary inout_summary cache_sum

REQUEST := messages distributed file_serv request

FCACHE := cache cilfiles filecache default_cache

GUARDED_ACCS := access_info guarded_access_base guarded_access \
	guarded_access_sep guarded_access_clust

MODSUMS := modsummaryi

ORIG_SYMEX := sym_types symsummary symstate2

NEW_SYMEX := symex_types symex_sum symex

SYMEX := symex_base $(ORIG_SYMEX) $(NEW_SYMEX)

OO_PARTITION := addr_taken global_addr_taken faddr_taken oo_partition

FIELD_PARTITION := field_partition

CALLG := summary_keys callg scc_cg

FP_ANALYSIS := fp_types fp_unify_globals fp_lattice_ops \
	fp_malloc fp_hashcons fp_slice globals_ref \
	fp_agg_merge fp_generalize fp_store usedef_index \
	void_arg gen_defaults fp_utils fp_summary fp_context_lim \
	fp_intraproc init_visit fp_analysis fp_cg_construct

FP_RCI_ANALYSIS := fp_rci_types fp_rci_unify_structs \
	fp_rci_unify_globals fp_rci_flow_insens fp_rci_lattice_ops \
	fp_rci_malloc fp_rci_hashcons fp_rci_slicer fp_rci_unify fp_rci_globals \
	fp_rci_store fp_rci_focus fp_rci_usedef \
	void_arg fp_rci_defaults fp_rci_utils fp_rci_summary \
	fp_rci_intraproc fp_rci_initial fp_rci_anal \
	fp_rci_cg

DIFF_CG = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) alias_types alias \
	$(CALLG) lvals backed_summary diff_fp_cg

DYNAMIC_CG = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	$(CALLG) id_fixer $(CIL_EXTRAS) dynamic_cg

LLVM_CG = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	$(CALLG) id_fixer $(CIL_EXTRAS) llvm_cg

ID_FIX_CG = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) \
	alias_types alias $(CALLG) lvals dot_lib \
	$(OO_PARTITION) $(FIELD_PARTITION) dumpcalls \
	filter_dumpcalls fix_id_cg 

TEST_PTA = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) pta_link_test alias_types \
	alias $(CALLG) lvals dumpcalls test_pta 

RACESUMMARY = racesummary racesummary_split
#racesummary_split
#racesummary_combined 

RACE = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared memcpy \
	checkpoint relative_set lockset $(GUARDED_ACCS) \
	warn_reports race_reports \
	$(REQUEST) safer_sum $(MODSUMS) $(RACESUMMARY) analysis_dep interDataflow \
	dataflow_info manage_sums intraDataflow $(SYMEX) racestate \
	roots race_warnings thread_needed_funcs race_anal 

DIFF_RACES = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) alias_types alias \
	$(CALLG) lvals threads shared relative_set lockset $(GUARDED_ACCS) \
	warn_reports race_reports diff_races

RADAR = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports \
	race_reports knowledge_pass \
	$(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) relative_df racestate roots \
	lockset_partitioner pseudo_access all_unlocks \
	race_warnings2 thread_needed_funcs radar_race \
	radar radar_rel radar_anal 

NULL = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports race_reports \
	$(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) racestate relative_df lockset_partitioner \
	pseudo_access all_unlocks \
	knowledge_pass rns null_warnings nullstate thread_needed_funcs null_anal 

NULL2 = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports \
	race_reports $(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) relative_df racestate roots \
	all_unlocks lockset_partitioner pseudo_access race_warnings2\
	knowledge_pass rns null_warnings nullstate2 thread_needed_funcs null2_anal 

NULL3 = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) \
	warn_reports race_reports \
	$(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow racestate \
	$(SYMEX) relative_df all_unlocks lockset_partitioner pseudo_access \
	knowledge_pass rns null_warnings nullstate2 nullstate3 \
	thread_needed_funcs null3_anal 

#---

NULLSET_RADAR = $(RADAR) nullset nullset_radar
NULLSET_RACE = $(RADAR) nullset nullset_race

#---

SYMEX_RADAR = $(RADAR) radar_symstate symex_radar
SYMEX_RACE = $(RADAR) radar_symstate symex_race

#---

CONST_PROP_RADAR = $(RADAR) modsum_call const_prop const_prop_radar
CONST_PROP_RACE = $(RADAR) modsum_call const_prop const_prop_race

#---

VERY_BUSY_RADAR = $(RADAR) modsum_call very_busy very_busy_radar
VERY_BUSY_RACE = $(RADAR) modsum_call very_busy very_busy_race

#---

PSEUDO_FILTER = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports \
	race_reports \
	$(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) relative_df racestate roots \
	all_unlocks lockset_partitioner pseudo_access race_warnings2 \
	knowledge_pass rns null_warnings nullstate2 pseudo_filter

RACE_TEMP = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points shared \
	checkpoint relative_set lockset $(GUARDED_ACCS) warn_reports race_reports \
	$(REQUEST) safer_sum $(MODSUMS) \
	$(RACESUMMARY) manage_sums analysis_dep interDataflow intraDataflow \
	$(SYMEX) relative_df lockset_partitioner \
	racestate all_unlocks racestate_temp \
	roots race_warnings thread_needed_funcs race_temp_anal 

RACE_TEMP2 = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls threads entry_points shared \
	checkpoint relative_set lockset $(GUARDED_ACCS) warn_reports race_reports \
	$(REQUEST) safer_sum $(MODSUMS) \
	$(RACESUMMARY) manage_sums analysis_dep interDataflow \
	intraDataflow $(SYMEX) relative_df \
	lockset_partitioner pseudo_access racestate \
	racestate_temp2 roots race_warnings2 thread_needed_funcs race_temp2_anal

SERVER_SOCKET = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CALLG) $(CIL_EXTRAS) $(BACKING_STORE) $(PTA) alias_types \
	alias dumpcalls lvals threads entry_points shared relative_set lockset \
	$(GUARDED_ACCS) warn_reports race_reports $(REQUEST) \
	checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	server_socket

CG_DOT = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CALLG) $(CIL_EXTRAS) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals \
	threads entry_points dot_lib cg_to_dot 

CAST_GRAPH_DOT = $(UTILS) $(DATA_STRUCTS) $(FCACHE) id_fixer $(CIL_EXTRAS) \
	test_cast_graph 

DEBUG_BLOCKED = $(UTILS) $(DATA_STRUCTS) $(FCACHE) id_fixer $(CIL_EXTRAS) \
	fstructs $(CALLG) debug_blocked

SCC_STATS = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CALLG) $(BACKING_STORE) \
	distributed $(CIL_EXTRAS) $(PTA) \
	alias_types alias lvals threads entry_points scc_plot scc_stats

SCC_COMPARE = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CALLG) $(BACKING_STORE) \
	distributed $(CIL_EXTRAS) $(PTA) \
	alias_types alias lvals \
	threads entry_points scc_plot scc_compare

INSTR_STATS = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) alias_types alias $(CALLG) lvals dumpcalls \
	threads entry_points shared relative_set lockset malloc_stats \
	dot_lib obj_stats basic_line_count \
	$(OO_PARTITION) $(FIELD_PARTITION) instr_stats

CFIELD_BUG = $(UTILS) $(DATA_STRUCTS) $(FCACHE) id_fixer $(CIL_EXTRAS) \
	cfields_bug

LOCK_STATS = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) alias_types alias $(CALLG) lvals \
	dumpcalls scc scc_cg \
	threads entry_points shared relative_set lockset \
	test_lock_kernel

TEST_MEMUSAGE = $(UTILS) test_memusage

TEST_PP_UNIQUENESS = $(UTILS) test_pp_uniqueness

PRINTSUMM = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CALLG) $(CIL_EXTRAS) \
	$(PTA) alias_types alias  $(BACKING_STORE) dumpcalls \
	lvals relative_set lockset threads entry_points \
	shared $(GUARDED_ACCS) warn_reports race_reports $(REQUEST) \
	checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) relative_df racestate \
	lockset_partitioner pseudo_access \
	all_unlocks knowledge_pass rns null_warnings \
	print_summary

PRINTCIL = print_cil

PRINTWARN = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) \
	alias_types alias $(CALLG) lvals dumpcalls \
	threads entry_points \
	checkpoint relative_set lockset \
	$(BACKING_STORE) shared $(GUARDED_ACCS) warn_reports race_reports \
	$(REQUEST) safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow $(SYMEX) racestate \
	roots race_warnings print_warnings

WARNSTATS = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(PTA) alias_types alias \
	$(CALLG) lvals $(BACKING_STORE) threads shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports race_reports $(REQUEST) \
	checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) warn_stats 

# figure out which ones are actually needed!
DEREFSTATS = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports race_reports \
	$(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) relative_df racestate all_unlocks \
	lockset_partitioner pseudo_access \
	knowledge_pass rns null_warnings dereference_stats

# figure out which ones are actually needed!
PRINTDELTA = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) \
	warn_reports race_reports \
	$(REQUEST) checkpoint safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow manage_sums intraDataflow \
	$(SYMEX) relative_df racestate all_unlocks \
	lockset_partitioner pseudo_access \
	knowledge_pass rns null_warnings print_delta


SYMSTATE = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CALLG) $(CIL_EXTRAS) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls \
	threads entry_points checkpoint shared \
	relative_set lockset $(GUARDED_ACCS) \
	warn_reports race_reports $(REQUEST) \
	manage_sums safer_sum $(MODSUMS) $(RACESUMMARY) \
	analysis_dep interDataflow intraDataflow \
	$(SYMEX) racestate test_symstate

FPANA = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias dumpcalls addr_taken faddr_taken obj_stats \
	prune_mallocs topdownDataflow \
	$(FP_ANALYSIS) analyze_fp


FP_RCI = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias dumpcalls addr_taken faddr_taken \
	global_addr_taken obj_stats \
	prune_mallocs df_notify rciDataflow \
	$(FP_RCI_ANALYSIS) fp_rci


TEST_DS = $(UTILS) $(DATA_STRUCTS) test_datastructs

TEST_INSPECT = $(UTILS) $(DATA_STRUCTS) $(FCACHE) fstructs \
	id_fixer $(CIL_EXTRAS) $(CALLG) $(BACKING_STORE) \
	$(PTA) alias_types alias lvals dumpcalls threads entry_points shared \
	relative_set lockset $(GUARDED_ACCS) warn_reports race_reports \
	checkpoint $(REQUEST) safer_sum $(MODSUMS) $(RACESUMMARY) \
	manage_sums analysis_dep interDataflow intraDataflow \
	$(SYMEX) racestate test_inspect 


BIN_TARGETS = fix_id_cg$(OPT_EXT) race_anal$(OPT_EXT) printwarn$(OPT_EXT) \
	printsumm$(OPT_EXT) scc_stats$(OPT_EXT) scc_compare$(OPT_EXT) \
	test_memusage$(OPT_EXT) test_ds$(OPT_EXT) test_symstate$(OPT_EXT) \
	cg_to_dot$(OPT_EXT) print_cil$(OPT_EXT) test_pta$(OPT_EXT) \
	server$(OPT_EXT) warn_stats$(OPT_EXT) instr_stats$(OPT_EXT) \
	deref_stats$(OPT_EXT) print_delta$(OPT_EXT) inspect$(OPT_EXT) \
	race_temp_anal$(OPT_EXT) \
	symex_radar$(OPT_EXT) symex_race$(OPT_EXT) \
	nullset_radar$(OPT_EXT) nullset_race$(OPT_EXT) \
	cast_graph$(OPT_EXT) \
	lock_stats$(OPT_EXT) const_prop_radar$(OPT_EXT) const_prop_race$(OPT_EXT) \
	very_busy_radar$(OPT_EXT) very_busy_race$(OPT_EXT) analyze_fp$(OPT_EXT) \
	cfields_bug$(OPT_EXT) debug_blocked$(OPT_EXT) fp_rci$(OPT_EXT) \
	diff_fp_cg$(OPT_EXT) dynamic_cg$(OPT_EXT) llvm_cg$(OPT_EXT) \
	diff_races$(OPT_EXT) null_anal$(OPT_EXT) 

# OLD version of RADAR
#    race_temp2_anal$(OPT_EXT) null2_anal$(OPT_EXT) \
#	pseudo_filter$(OPT_EXT) null3_anal$(OPT_EXT) \
#sym_seq$(OPT_EXT) sym_adj_l$(OPT_EXT) sym_adj_nl$(OPT_EXT) sym_pess$(OPT_EXT) \
#nullset_seq$(OPT_EXT) nullset_adj_l$(OPT_EXT) nullset_adj_nl$(OPT_EXT) \
#	nullset_pess$(OPT_EXT) 

BYTE_TARGETS = fix_id_cg$(BYTE_EXT) race$(BYTE_EXT) printwarn$(BYTE_EXT) \
	printsumm$(BYTE_EXT) merge$(BYTE_EXT) runtest$(BYTE_EXT) \
	symstate$(BYTE_EXT) cg_to_dot$(BYTE_EXT) test_pta$(BYTE_EXT) \
	server$(BYTE_EXT) warn_stats$(BYTE_EXT) instr_stats$(BYTE_EXT) \
	inspect$(BYTE_EXT) print_cil$(BYTE_EXT) race_temp_anal$(BYTE_EXT) \
	symex_radar$(BYTE_EXT) symex_race$(BYTE_EXT) \
	nullset_radar$(BYTE_EXT) nullset_race$(BYTE_EXT) \
	const_prop_radar$(BYTE_EXT) const_prop_race$(BYTE_EXT) \
	very_busy_radar$(BYTE_EXT) very_busy_race$(BYTE_EXT) \
	cast_graph$(BYTE_EXT) analyze_fp$(BYTE_EXT) cfields_bug$(BYTE_EXT) \
	debug_blocked$(BYTE_EXT) fp_rci$(BYTE_EXT) 

# OLD version of RADAR
#   null$(BYTE_EXT) race_temp2_anal$(BYTE_EXT) null2$(BYTE_EXT) \
#	pseudo_filter$(BYTE_EXT) null3$(BYTE_EXT) \
#   sym_race$(BYTE_EXT) sym_seq$(BYTE_EXT) sym_adj_l$(BYTE_EXT) \
#	sym_adj_nl$(BYTE_EXT) sym_pess$(BYTE_EXT) 
#   nullset_seq$(BYTE_EXT) nullset_adj_l$(BYTE_EXT) nullset_adj_nl$(BYTE_EXT) 
# nullset_pess$(BYTE_EXT)

ALL_TARGETS = .depend $(BIN_TARGETS) $(BYTE_TARGETS)

.PHONY: all clean htmldoc dot

all: .depend $(BIN_TARGETS)



#--------------------------------------------------------
# ML <-> C interface files (requires the C obj file also)

statfs.cmo: statfs.ml statfs_c.o
	$(OCAMLC) $(OCAMLFLAGS) -custom -c $<

statfs.cmx: statfs.ml statfs_c.o
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c $<


#--------------------------------------------------
# Fix ids + dump the call graph


ID_FIX_CG_OBJS = $(addsuffix .cmx, $(ID_FIX_CG))

fix_id_cg$(OPT_EXT): $(ID_FIX_CG_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


ID_FIX_CG_BYTE = $(addsuffix .cmo, $(ID_FIX_CG))

fix_id_cg$(BYTE_EXT): $(ID_FIX_CG_BYTE)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^


#--------------------------------------------------
# Fix ids + dump the call graph

TEST_PTA_OBJS = $(addsuffix .cmx, $(TEST_PTA))

test_pta$(OPT_EXT): $(TEST_PTA_OBJS)
	$(OCAMLOPT) -ccopt -static -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


TEST_PTA_BYTE = $(addsuffix .cmo, $(TEST_PTA))

test_pta$(BYTE_EXT): $(TEST_PTA_BYTE)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^


#--------------------------------------------------
# Relay

# The list of object files for the byte code version
RACE_BYTE_OBJS = $(addsuffix .cmo, $(RACE))

race$(BYTE_EXT): $(RACE_BYTE_OBJS)
	$(OCAMLC) -ccopt -static -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

# The list of object files for the native version
RACE_NATIVE_OBJS = $(addsuffix .cmx, $(RACE))

race_anal$(OPT_EXT): $(RACE_NATIVE_OBJS)
	$(OCAMLOPT) -ccopt -static -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#------------------------------------------------------------
# Old non-functorized radar

# The list of object files for the byte code version
NULL_BYTE_OBJS = $(addsuffix .cmo, $(NULL))

null$(BYTE_EXT): $(NULL_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

# The list of object files for the native version
NULL_NATIVE_OBJS = $(addsuffix .cmx, $(NULL))

null_anal$(OPT_EXT): $(NULL_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

NULL2_BYTE_OBJS = $(addsuffix .cmo, $(NULL2))

null2$(BYTE_EXT): $(NULL2_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

NULL2_NATIVE_OBJS = $(addsuffix .cmx, $(NULL2))

null2_anal$(OPT_EXT): $(NULL2_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

### NULL3

NULL3_BYTE_OBJS = $(addsuffix .cmo, $(NULL3))

null3$(BYTE_EXT): $(NULL3_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

NULL3_NATIVE_OBJS = $(addsuffix .cmx, $(NULL3))

null3_anal$(OPT_EXT): $(NULL3_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#------------------------------------------------------------
##### Newer functorized versions

NULLSET_RADAR_BYTE_OBJS = $(addsuffix .cmo, $(NULLSET_RADAR))

nullset_radar$(BYTE_EXT): $(NULLSET_RADAR_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

NULLSET_RADAR_NATIVE_OBJS = $(addsuffix .cmx, $(NULLSET_RADAR))

nullset_radar$(OPT_EXT): $(NULLSET_RADAR_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

NULLSET_RACE_BYTE_OBJS = $(addsuffix .cmo, $(NULLSET_RACE))

nullset_race$(BYTE_EXT): $(NULLSET_RACE_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

NULLSET_RACE_NATIVE_OBJS = $(addsuffix .cmx, $(NULLSET_RACE))

nullset_race$(OPT_EXT): $(NULLSET_RACE_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#------------------------------------------------------------

SYMEX_RADAR_BYTE_OBJS = $(addsuffix .cmo, $(SYMEX_RADAR))

symex_radar$(BYTE_EXT): $(SYMEX_RADAR_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

SYMEX_RADAR_NATIVE_OBJS = $(addsuffix .cmx, $(SYMEX_RADAR))

symex_radar$(OPT_EXT): $(SYMEX_RADAR_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

SYMEX_RACE_BYTE_OBJS = $(addsuffix .cmo, $(SYMEX_RACE))

symex_race$(BYTE_EXT): $(SYMEX_RACE_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

SYMEX_RACE_NATIVE_OBJS = $(addsuffix .cmx, $(SYMEX_RACE))

symex_race$(OPT_EXT): $(SYMEX_RACE_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#------------------------------------------------------------

CONST_PROP_RADAR_BYTE_OBJS = $(addsuffix .cmo, $(CONST_PROP_RADAR))

const_prop_radar$(BYTE_EXT): $(CONST_PROP_RADAR_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

CONST_PROP_RADAR_NATIVE_OBJS = $(addsuffix .cmx, $(CONST_PROP_RADAR))

const_prop_radar$(OPT_EXT): $(CONST_PROP_RADAR_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

CONST_PROP_RACE_BYTE_OBJS = $(addsuffix .cmo, $(CONST_PROP_RACE))

const_prop_race$(BYTE_EXT): $(CONST_PROP_RACE_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

CONST_PROP_RACE_NATIVE_OBJS = $(addsuffix .cmx, $(CONST_PROP_RACE))

const_prop_race$(OPT_EXT): $(CONST_PROP_RACE_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#------------------------------------------------------------

VERY_BUSY_RADAR_BYTE_OBJS = $(addsuffix .cmo, $(VERY_BUSY_RADAR))

very_busy_radar$(BYTE_EXT): $(VERY_BUSY_RADAR_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

VERY_BUSY_RADAR_NATIVE_OBJS = $(addsuffix .cmx, $(VERY_BUSY_RADAR))

very_busy_radar$(OPT_EXT): $(VERY_BUSY_RADAR_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

VERY_BUSY_RACE_BYTE_OBJS = $(addsuffix .cmo, $(VERY_BUSY_RACE))

very_busy_race$(BYTE_EXT): $(VERY_BUSY_RACE_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

VERY_BUSY_RACE_NATIVE_OBJS = $(addsuffix .cmx, $(VERY_BUSY_RACE))

very_busy_race$(OPT_EXT): $(VERY_BUSY_RACE_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#------------------------------------------------------------

PSEUDO_FILTER_BYTE_OBJS = $(addsuffix .cmo, $(PSEUDO_FILTER))

pseudo_filter$(BYTE_EXT): $(PSEUDO_FILTER_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

PSEUDO_FILTER_NATIVE_OBJS = $(addsuffix .cmx, $(PSEUDO_FILTER))

pseudo_filter$(OPT_EXT): $(PSEUDO_FILTER_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#
RACE_TEMP_BYTE_OBJS = $(addsuffix .cmo, $(RACE_TEMP))

race_temp_anal$(BYTE_EXT): $(RACE_TEMP_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

RACE_TEMP_NATIVE_OBJS = $(addsuffix .cmx, $(RACE_TEMP))

race_temp_anal$(OPT_EXT): $(RACE_TEMP_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

RACE_TEMP2_BYTE_OBJS = $(addsuffix .cmo, $(RACE_TEMP2))

race_temp2_anal$(BYTE_EXT): $(RACE_TEMP2_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

RACE_TEMP2_NATIVE_OBJS = $(addsuffix .cmx, $(RACE_TEMP2))

race_temp2_anal$(OPT_EXT): $(RACE_TEMP2_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#--------------------------------------------------
# Diff races

DIFF_RACES_NATIVE_OBJS = $(addsuffix .cmx, $(DIFF_RACES))

diff_races$(OPT_EXT): $(DIFF_RACES_NATIVE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

DIFF_RACES_BYTE_OBJS = $(addsuffix .cmo, $(DIFF_RACES))

diff_races$(BYTE_EXT): $(DIFF_RACES_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Server for distributed mode (using sockets)

# The list of object files for the byte code version
SERVER_SOCKET_BYTE_OBJS = $(addsuffix .cmo, $(SERVER_SOCKET))

server$(BYTE_EXT): $(SERVER_SOCKET_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

# The list of object files for the native version
SERVER_SOCKET_NATIVE_OBJS = $(addsuffix .cmx, $(SERVER_SOCKET))

server$(OPT_EXT): $(SERVER_SOCKET_NATIVE_OBJS)
	$(OCAMLOPT) -ccopt -static -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#--------------------------------------------------
# Convert cg to dot graphs

CG_DOT_OBJS = $(addsuffix .cmx, $(CG_DOT))

cg_to_dot$(OPT_EXT): $(CG_DOT_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

CG_DOT_BYTE_OBJS = $(addsuffix .cmo, $(CG_DOT))

cg_to_dot$(BYTE_EXT): $(CG_DOT_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^


#--------------------------------------------------
# Graph out type casting occurrences

CAST_OBJS = $(addsuffix .cmx, $(CAST_GRAPH_DOT))

cast_graph$(OPT_EXT): $(CAST_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

CAST_BYTE_OBJS = $(addsuffix .cmo, $(CAST_GRAPH_DOT))

cast_graph$(BYTE_EXT): $(CAST_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Debug blocked functions in top-down analysis

DEBUG_BLOCKED_OBJS = $(addsuffix .cmx, $(DEBUG_BLOCKED))

debug_blocked$(OPT_EXT): $(DEBUG_BLOCKED_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

DEBUG_BLOCKED_BYTE_OBJS = $(addsuffix .cmo, $(DEBUG_BLOCKED))

debug_blocked$(BYTE_EXT): $(DEBUG_BLOCKED_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^


#--------------------------------------------------
# Scc stat printer

SCC_STATS_OBJS = $(addsuffix .cmx, $(SCC_STATS))

scc_stats$(OPT_EXT): $(SCC_STATS_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#--------------------------------------------------
# Scc comparison printer

SCC_COMPARE_OBJS = $(addsuffix .cmx, $(SCC_COMPARE))

scc_compare$(OPT_EXT): $(SCC_COMPARE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#--------------------------------------------------
# Instr stat printer

INSTR_STATS_OBJS = $(addsuffix .cmx, $(INSTR_STATS))

instr_stats$(OPT_EXT): $(INSTR_STATS_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

INSTR_STATS_BYTE_OBJS = $(addsuffix .cmo, $(INSTR_STATS))

instr_stats$(BYTE_EXT): $(INSTR_STATS_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Cfields bug checker

CFIELD_BUG_OBJS = $(addsuffix .cmx, $(CFIELD_BUG))

cfields_bug$(OPT_EXT): $(CFIELD_BUG_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

CFIELD_BUG_BYTE_OBJS = $(addsuffix .cmo, $(CFIELD_BUG))

cfields_bug$(BYTE_EXT): $(CFIELD_BUG_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS) \
	$(CIL_OBJS)/cil.cma $^


#--------------------------------------------------
# Lock_kernel stats

LOCK_STATS_OBJS = $(addsuffix .cmx, $(LOCK_STATS))

lock_stats$(OPT_EXT): $(LOCK_STATS_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#--------------------------------------------------
# Load / Run some analyses test

TEST_MEMUSAGE_OBJS = $(addsuffix .cmx, $(TEST_MEMUSAGE))

test_memusage$(OPT_EXT): $(TEST_MEMUSAGE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

TEST_MEMUSAGE_BYTE_OBJS = $(addsuffix .cmo, $(TEST_MEMUSAGE))

runtest$(BYTE_EXT): $(TEST_MEMUSAGE_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Load / Echo a summary

PRINTSUMM_OBJS = $(addsuffix .cmx, $(PRINTSUMM))

printsumm$(OPT_EXT): $(PRINTSUMM_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

PRINTSUMM_BYTE_OBJS = $(addsuffix .cmo, $(PRINTSUMM))

printsumm$(BYTE_EXT): $(PRINTSUMM_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Load and print a CIL ast

PRINT_CIL_OBJS = $(addsuffix .cmx, $(PRINTCIL))

print_cil$(OPT_EXT): $(PRINT_CIL_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

PRINT_CIL_BYTE_OBJS = $(addsuffix .cmo, $(PRINTCIL))

print_cil$(BYTE_EXT): $(PRINT_CIL_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Load summaries, print race_warnings

PRINTWARN_OBJS = $(addsuffix .cmx, $(PRINTWARN))

printwarn$(OPT_EXT): $(PRINTWARN_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

PRINTWARN_BYTE_OBJS = $(addsuffix .cmo, $(PRINTWARN))

printwarn$(BYTE_EXT): $(PRINTWARN_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Load warning data, print statistics

WARNSTATS_OBJS = $(addsuffix .cmx, $(WARNSTATS))

warn_stats$(OPT_EXT): $(WARNSTATS_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

WARNSTATS_BYTE_OBJS = $(addsuffix .cmo, $(WARNSTATS))

warn_stats$(BYTE_EXT): $(WARNSTATS_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#
DEREFSTATS_OBJS = $(addsuffix .cmx, $(DEREFSTATS))

deref_stats$(OPT_EXT): $(DEREFSTATS_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#
PRINTDELTA_OBJS = $(addsuffix .cmx, $(PRINTDELTA))

print_delta$(OPT_EXT): $(PRINTDELTA_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


#--------------------------------------------------
# Test the symstate analysis

SYMSTATE_OBJS = $(addsuffix .cmx, $(SYMSTATE))

test_symstate$(OPT_EXT): $(SYMSTATE_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

SYMSTATE_BYTE_OBJS = $(addsuffix .cmo, $(SYMSTATE))

symstate$(BYTE_EXT): $(SYMSTATE_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Test the function pointer analysis

FP_OBJS = $(addsuffix .cmx, $(FPANA))

analyze_fp$(OPT_EXT): $(FP_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


FP_BYTE_OBJS = $(addsuffix .cmo, $(FPANA))

analyze_fp$(BYTE_EXT): $(FP_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Test the function pointer analysis

FP_RCI_OBJS = $(addsuffix .cmx, $(FP_RCI))

fp_rci$(OPT_EXT): $(FP_RCI_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


FP_RCI_BYTE_OBJS = $(addsuffix .cmo, $(FP_RCI))

fp_rci$(BYTE_EXT): $(FP_RCI_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------

DIFF_CG_OBJS = $(addsuffix .cmx, $(DIFF_CG))

diff_fp_cg$(OPT_EXT): $(DIFF_CG_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#--------------------------------------------------

DYNAMIC_CG_OBJS = $(addsuffix .cmx, $(DYNAMIC_CG))

dynamic_cg$(OPT_EXT): $(DYNAMIC_CG_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

#--------------------------------------------------

LLVM_CG_OBJS = $(addsuffix .cmx, $(LLVM_CG))

llvm_cg$(OPT_EXT): $(LLVM_CG_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^

LLVM_CG_BYTE_OBJS = $(addsuffix .cmo, $(LLVM_CG))

llvm_cg$(BYTE_EXT): $(LLVM_CG_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^

#--------------------------------------------------
# Simple post-analysis, re-analysis + inspection

INSPECT_OBJS = $(addsuffix .cmx, $(TEST_INSPECT))

inspect$(OPT_EXT): $(INSPECT_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^


INSPECT_BYTE_OBJS = $(addsuffix .cmo, $(TEST_INSPECT))

inspect$(BYTE_EXT): $(INSPECT_BYTE_OBJS)
	$(OCAMLC) -o $@ $(OCAMLFLAGS)  \
	$(CIL_OBJS)/cil.cma $^



#--------------------------------------------------
# Test memory usage for data structures

TEST_DS_OBJS = $(addsuffix .cmx, $(TEST_DS))

test_ds$(OPT_EXT): $(TEST_DS_OBJS)
	$(OCAMLOPT) -o $@ $(OCAMLOPTFLAGS) \
	$(CIL_OBJS)/cil.cmxa $^



#--------------------------------------------------
# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c $<

.c.o:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c $<


#--------------------------------------------------
# Clean up


clean:
	rm -f $(ALL_TARGETS)
	rm -f *.cm[iox]
	rm -f *.annot
	rm -f *.o
	rm -f *.*~
	$(foreach dir,$(VPATH), rm -f $(dir)/*.cm[iox])
	$(foreach dir,$(VPATH), rm -f $(dir)/*.o)
	$(foreach dir,$(VPATH), rm -f $(dir)/*.*~)
	$(foreach dir,$(VPATH), rm -f $(dir)/*.annot)

# TODO: have Makefiles in subdirs that just do this...


#--------------------------------------------------
# Dependencies

MLI_DEPENDS=$(addsuffix /*.mli,$(VPATH))
ML_DEPENDS=$(addsuffix /*.ml,$(VPATH))

.depend:
	$(OCAMLDEP) $(INCLUDES) \
	$(MLI_DEPENDS) $(ML_DEPENDS) \
	*.mli *.ml > .depend
# $(DS_DIR)/*.mli $(DS_DIR)/*.ml \
# $(PTA_DIR)/*.mli $(PTA_DIR)/*.ml \
# $(FP_DIR)/*.mli $(FP_DIR)/*.ml \
# $(FP_RCI_DIR)/*.mli $(FP_RCI_DIR)/*.ml \

include .depend


#-------------------------------------------------------
# TODO FIX THIS DOC generation
#

htmldoc:
	$(OCAMLDOC) $(INCLUDES) -d /tmp/ocamldocs -html cilexts/*.ml \
		datastructs/*.ml pta/*.ml *.ml

dot:
	$(OCAMLDOC) $(INCLUDES) -sort -dot cilexts/*.ml datastructs/*.ml *.ml 
