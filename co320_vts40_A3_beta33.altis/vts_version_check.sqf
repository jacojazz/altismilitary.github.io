_product=productVersion;

if ((_product select 1)=="Arma3Alpha" or (_product select 1)=="Arma3" or (_product select 1)=="Arma3Beta") then
{
	#define vts_version_ok
	#define vts_arma3
};