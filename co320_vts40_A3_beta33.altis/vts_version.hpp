//Define wich data to use (assure compatibility with other Arma version)
#ifndef vts_version_ok
	//#define vts_arma2
	//#define vts_arma2oa
	#define vts_arma3
#endif


#ifdef vts_arma2
	//A2
	vts_armaversion = 2;
	//Interfaces
	#include "vts_ui_a2.hpp"
	#include "mods\vts_a2_units.hpp"
	
#endif

#ifdef vts_arma2oa
	//A2 OA
	vts_armaversion = 2;
	//Interfaces
	#include "vts_ui_a2.hpp"
	#include "mods\vts_a2oa_units.hpp"
	
#endif


#ifdef vts_arma3
	//Arma3
	vts_armaversion = 3;

	//Interfaces
	#include "vts_ui_a3.hpp"
	#include "mods\vts_a3_units.hpp"
	
#endif