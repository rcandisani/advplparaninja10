#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} A010TOK

Ponto de entrada na grava��o do produto 
@sample		
@author 	Rogerio O Candisani	
@since		 
@version 	P12

@param		
/*/
User function A010TOK()

Local lRet := .T.
Local cTipo := M->B1_TIPO //se for tela em MVC FWFLDGET("B1_TIPO")
Local cTesSaida:= M->B1_TS
//Alert("Ponto de entrada A010TOK")
//verificar se for PA n�o deixar gravar sem o Tes de sa�da
If cTipo == "PA"
	If empty(cTesSaida)
		MsgAlert("Informar a TES de sa�da padr�o para o faturamento","Aten��o")
		lRet:= .F.
	Endif	
Endif

Return lRet