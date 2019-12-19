#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//------------------------------------------------------------------------------
/*{Protheus.doc} VLDHORAS
Rotina para validar hora digitada

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function VldHoras(cHora)

Local lRet		:= .F.
Local cHoras	:= Substr(cHora,1,2)
Local cMinutos := Substr(cHora,4,2)

If cHoras >= "00" .And. cHoras < "24" .And. cMinutos >= "00" .And. cMinutos < "60"
	lRet := .T.
EndIf
If ( !lRet)
	Help(" ",1,"VLDHORA")
EndIf
Return(lRet)
