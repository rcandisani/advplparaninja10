#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//------------------------------------------------------------------------------
/*{Protheus.doc} ADV022
Rotina para montagem do execauto de inclusão de pedido de venda

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADV022()

Local aCabec:= {}
Local aItens:= {}
Local aAuxItem:= {}

Local nQtde:= ""
Local nVlrUnit:= ""
Local nVlrTotal:= ""
Local lMsErroAuto:= .T. 
	
	
	//-------------------------------------------------------------
	// rotina para importar um pedido de venda via execauto
	//-------------------------------------------------------------
	aadd(aCabec,{"C5_NUM"		,"100000"	,Nil})
	aadd(aCabec,{"C5_TIPO"		,"N"		,Nil})
	aadd(aCabec,{"C5_CLIENTE"	,"000001"	,Nil})
	aadd(aCabec,{"C5_LOJACLI"	,"01"   	,Nil})
	aadd(aCabec,{"C5_CONDPAG"	,'01'		,Nil})
	aadd(aCabec,{"C5_MOEDA"  	,1			,Nil})
	
	//-------------------------------------------------------------
	// grava detalhes dos itens do pedido de venda
	//-------------------------------------------------------------
	aLinha := {}
	aadd(aLinha,{"C6_ITEM"		,"01"		,Nil})
	aadd(aLinha,{"C6_PRODUTO"	,"PA001"	,Nil})
	aadd(aLinha,{"C6_QTDVEN"	,10			,Nil})
	aadd(aLinha,{"C6_PRCVEN"	,100		,Nil})
	aadd(aLinha,{"C6_PRUNIT"	,100		,Nil})
	aadd(aLinha,{"C6_VALOR"		,1000		,Nil})
	aadd(aLinha,{"C6_TES"     	,"501"      ,Nil})
	aadd(aItens,aLinha)
	
	//| Teste de Inclusao                                            |
	LjMsgRun("Importando pedido de venda, aguarde...")
	MSExecAuto({|x,y,z| mata410(x,y,z)},aCabec,aItens,3)
					
	If !lMsErroAuto
		MsgInfo("Importação realizada com sucesso!","INFO")
	Else
		MostraErro()
		DisarmTransaction()
	EndIf
Return