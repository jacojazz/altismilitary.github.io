
//Dummy
vts_sys_smallworkdummy="Sign_Sphere25cm_F";
vts_sys_dummy3darrow="Sign_Arrow_Large_F";
vts_sys_dummyvehicle="Rabbit_f";
vts_sys_weaponholder="groundweaponHolder";

//Compo
vts_sys_compofence="Land_Razorwire_F";
vts_sys_compolowwall="Land_HBarrier_3_F";
vts_sys_compofireplace="FirePlace_burning_F";
vts_sys_compobuildingnest="Land_Cargo_HQ_V2_F";
vts_sys_compobuildingmash="MASH";
vts_sys_compoflag="FlagChecked_F";
vts_sys_emptyhelipad="Land_HelipadEmpty_F";
vts_sys_crater="CraterLong";

//Explosives
vts_sys_lowexplosive="R_60mm_HE";
vts_sys_mediumexplosive="R_80mm_HE";
vts_sys_highexplosive="Bo_GBU12_LGB";	

//Vehicule parachute
vts_sys_vehparachute="I_Parachute_02_F";
vts_sys_parachute="Steerable_Parachute_F";

//Editor objects
#define vts_sys_dummy "Sign_Sphere10cm_F"
#define vts_sys_spawn "Land_Cargo_House_V1_F"

#define vts_sys_gmunit "B_Soldier_lite_F"

//("Sign_Sphere10cm_F")|("Land_Cargo_House_V1_F")|("B_Soldier_lite_F")|("B_Soldier_SL_F")|("B_Soldier_F")|("B_medic_F")|("B_soldier_repair_F")|("B_soldier_AR_F")|("B_soldier_TL_F")|("B_soldier_LAT_F")|("B_Helipilot_F")|("O_Soldier_SL_F")|("O_Soldier_F")|("O_medic_F")|("O_soldier_repair_F")|("O_soldier_AR_F")|("O_soldier_M_F")|("O_soldier_LAT_F")|("O_Helipilot_F")|("I_Soldier_SL_F")|("I_Soldier_F")|("I_medic_F")|("I_soldier_repair_F")|("I_soldier_AR_F")|("I_soldier_M_F")|("I_soldier_LAT_F")|("I_Helipilot_F")|("C_man_1_1_F")|("C_man_1_2_F")|("C_man_1_3_F")|("C_man_polo_1_F")|("C_man_polo_2_F")|("C_man_polo_3_F")|("C_man_polo_4_F")|("C_man_polo_5_F")
//(?1vts_sys_dummy)(?2vts_sys_spawn)(?3vts_sys_gmunit)(?4vts_sys_b_unit_leader)(?5vts_sys_b_unit_soldier)(?6vts_sys_b_unit_medic)(?7vts_sys_b_unit_engineer)(?8vts_sys_b_unit_auto)(?9vts_sys_b_unit_markman)(?10vts_sys_b_unit_at)(?11vts_sys_b_unit_pilot)(?12vts_sys_o_unit_leader)(?13vts_sys_o_unit_soldier)(?14vts_sys_o_unit_medic)(?15vts_sys_o_unit_engineer)(?16vts_sys_o_unit_auto)(?17vts_sys_o_unit_markman)(?18vts_sys_o_unit_at)(?19vts_sys_o_unit_pilot)(?20vts_sys_i_unit_leader)(?21vts_sys_i_unit_soldier)(?22vts_sys_i_unit_medic)(?23vts_sys_i_unit_engineer)(?24vts_sys_i_unit_auto)(?25vts_sys_i_unit_markman)(?26vts_sys_i_unit_at)(?27vts_sys_i_unit_pilot)(?28vts_sys_c_unit_leader)(?29vts_sys_c_unit_soldier)(?30vts_sys_c_unit_medic)(?31vts_sys_c_unit_engineer)(?32vts_sys_c_unit_auto)(?33vts_sys_c_unit_markman)(?34vts_sys_c_unit_at)(?35vts_sys_c_unit_pilot)

//("Sign_Sphere10cm_F")|("Land_Cargo_House_V1_F")|("B_Soldier_lite_F")
//(?1vts_sys_dummy)(?2vts_sys_spawn)(?3vts_sys_gmunit)

//|("B_Soldier_SL_F")|("B_Soldier_F")|("B_medic_F")|("B_soldier_repair_F")|("B_soldier_AR_F")|("B_soldier_TL_F")|("B_soldier_LAT_F")|("B_Helipilot_F")
//(?4vts_sys_b_unit_leader)(?5vts_sys_b_unit_soldier)(?6vts_sys_b_unit_medic)(?7vts_sys_b_unit_engineer)(?8vts_sys_b_unit_auto)(?9vts_sys_b_unit_markman)(?10vts_sys_b_unit_at)(?11vts_sys_b_unit_pilot)

#define vts_sys_b_unit_leader "B_Soldier_SL_F"
#define vts_sys_b_unit_soldier "B_Soldier_F"
#define vts_sys_b_unit_medic "B_medic_F"
#define vts_sys_b_unit_engineer "B_soldier_repair_F"
#define vts_sys_b_unit_auto "B_soldier_AR_F"
#define vts_sys_b_unit_markman "B_soldier_TL_F"
#define vts_sys_b_unit_at "B_soldier_LAT_F"
#define vts_sys_b_unit_pilot "B_Helipilot_F"

//|("O_Soldier_SL_F")|("O_Soldier_F")|("O_medic_F")|("O_soldier_repair_F")|("O_soldier_AR_F")|("O_soldier_TL_F")|("O_soldier_LAT_F")|("O_Helipilot_F")
//(?12vts_sys_o_unit_leader)(?13vts_sys_o_unit_soldier)(?14vts_sys_o_unit_medic)(?15vts_sys_o_unit_engineer)(?16vts_sys_o_unit_auto)(?17vts_sys_o_unit_markman)(?18vts_sys_o_unit_at)(?19vts_sys_o_unit_pilot)

#define vts_sys_o_unit_leader "O_Soldier_SL_F"
#define vts_sys_o_unit_soldier "O_Soldier_F"
#define vts_sys_o_unit_medic "O_medic_F"
#define vts_sys_o_unit_engineer "O_soldier_repair_F"
#define vts_sys_o_unit_auto "O_soldier_AR_F"
#define vts_sys_o_unit_markman "O_soldier_TL_F"
#define vts_sys_o_unit_at "O_soldier_LAT_F"
#define vts_sys_o_unit_pilot "O_Helipilot_F"

//|("I_Soldier_SL_F")|("I_Soldier_F")|("I_medic_F")|("I_soldier_repair_F")|("I_soldier_AR_F")|("I_soldier_M_F")|(""I_soldier_LAT_F)|("I_Helipilot_F")
//(?20vts_sys_i_unit_leader)(?21vts_sys_i_unit_soldier)(?22vts_sys_i_unit_medic)(?23vts_sys_i_unit_engineer)(?24vts_sys_i_unit_auto)(?25vts_sys_i_unit_markman)(?26vts_sys_i_unit_at)(?27vts_sys_i_unit_pilot)

#define vts_sys_i_unit_leader "I_Soldier_SL_F"
#define vts_sys_i_unit_soldier "I_Soldier_F"
#define vts_sys_i_unit_medic "I_medic_F"
#define vts_sys_i_unit_engineer "I_soldier_repair_F"
#define vts_sys_i_unit_auto "I_soldier_AR_F"
#define vts_sys_i_unit_markman "I_soldier_TL_F"
#define vts_sys_i_unit_at "I_soldier_LAT_F"
#define vts_sys_i_unit_pilot "I_Helipilot_F"	

//|("C_man_1_1_F")|("C_man_1_2_F")|("C_man_1_3_F")|("C_man_polo_1_F")|("C_man_polo_2_F")|("C_man_polo_3_F")|(""C_man_polo_4_F)|("C_man_polo_5_F")
//(?28vts_sys_c_unit_leader)(?29vts_sys_c_unit_soldier)(?30vts_sys_c_unit_medic)(?31vts_sys_c_unit_engineer)(?32vts_sys_c_unit_auto)(?33vts_sys_c_unit_markman)(?34vts_sys_c_unit_at)(?35vts_sys_c_unit_pilot)

#define vts_sys_c_unit_leader "C_man_1_1_F"
#define vts_sys_c_unit_soldier "C_man_1_2_F"
#define vts_sys_c_unit_medic "C_man_1_3_F"
#define vts_sys_c_unit_engineer "C_man_polo_1_F"
#define vts_sys_c_unit_auto "C_man_polo_2_F"
#define vts_sys_c_unit_markman "C_man_polo_3_F"
#define vts_sys_c_unit_at "C_man_polo_4_F"
#define vts_sys_c_unit_pilot "C_man_polo_5_F"	
