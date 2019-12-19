#Include 'Protheus.ch'

/*/{Protheus.doc} M410LIOK

Ponto de entrada na validação da gravação do pedido de venda 
@sample		
@author 	Rogerio O Candisani	
@since		 
@version 	P12

@param		
/*/

User Function MT410TOK()

Local nPosProd := Ascan(aHeader,{|x| AllTrim(x[2]) == 'C6_PRODUTO'})
Local nCount := 0
Local lRet := .T.
Local cTpProd	:= ""

//verificar na gravação do pedido de venda se existe algum item <> "PA"
For nCount := 1 to Len(aCols)
	If !aCols[nCount,Len(aHeader)+1] //verificar se não está deletada a linha
	cTpProd	:= Posicione("SB1",1,xFilial("SB1")+aCols[nCount][nPosProd],"B1_TIPO")
		If cTpProd <> "PA"
			lRet := .F.
			nCount := Len(aCols) //ir para o ultimo registro para sair do while
			MsgAlert("Existem produtos diferentes do tipo PA, favor verificar")
		Endif
	Endif	
Next

Return lRet
