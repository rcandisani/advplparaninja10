#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//------------------------------------------------------------------------------
/*{Protheus.doc} ADV019
Rotina para montagem do execauto de inclusão de clientes

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADV019()

Local aCli := {}
Local lMsErroAuto := .T.  
Local lRet := .T.   

//informe os campos obrigatórios 
aAdd(aCli, {"A1_FILIAL" , xFilial()        , Nil}) 
aAdd(aCli, {"A1_COD"    ,"999999"          , Nil}) 
aAdd(aCli, {"A1_LOJA"   , '01'             , Nil}) 
aAdd(aCli, {"A1_Pessoa" , "F"              , Nil}) 
aAdd(aCli, {"A1_NOME"   , "TESTE EXECAUTO" , Nil}) 
aAdd(aCli, {"A1_NREDUZ" , "TESTE EXECAUTO" , Nil}) 
aAdd(aCli, {"A1_END"     ,"ENDERECO TESTE" , Nil}) 
aAdd(aCli, {"A1_TIPO"    ,"F"              , NIL}) 
aAdd(aCli, {"A1_EST"     ,"SP"             , Nil}) 
aAdd(aCli, {"A1_COD_MUN" ,"50308"          , Nil}) 
aAdd(aCli, {"A1_MUN"     ,"SAO PAULO"      , Nil}) 
aAdd(aCli, {"A1_CODPAIS" ,"01058"          , Nil})                                              

//exceauto do cadastro de cliente   
MsExecAuto({|x,y| MATA030(x,y)}, aCli, 3) 
If lMsErroAuto 
   MostraErro()     
   lRet := .f. 
Else
   confirmsx8()
   MsgBox("Cliente incluído com sucesso!")
EndIf 

Return lRet