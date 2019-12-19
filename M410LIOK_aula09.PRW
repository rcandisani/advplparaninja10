#include "rwmake.ch"

// P.E. quando muda a linha do pedido  

//-------------------------------------------------------------------
/*/{Protheus.doc} M410LIOK

Ponto de entrada na validação da linha do pedido de venda 
@sample		
@author 	Rogerio O Candisani	
@since		 
@version 	P12

@param		
/*/
User Function M410LIOK()

Local _lRet := .T.
Local x		:= 0
Local nCont := 0
//verificar o aCols           
_nProduto  	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
_cProduto  	:= Acols[n,_nProduto] // n - variavel publica nesta tela

//posicionar na tabela SB1 e verificar o tipo de produto
  
cTpProd	:= Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_TIPO")   
If !aCols[n,Len(aHeader)+1] 
	If cTpProd <> "PA" // só pode vender produto acabado
		Alert("Somente pode vender produto acabado.") 
		_lRet := .F.
	Endif 
Endif

//verificar se tem mais do que 3 itens no pedido de venda
nCont:= 0
For x:= 1 to len(aCols) 
	If !aCols[n,Len(aHeader)+1]
		++nCont
		If nCont > 3
			_lRet := .F.
			MsgStop("Não permitido incluir mais do que 3 itens no pedido de venda,Pare!")
		Endif
	Endif	
Next x
Return(_lRet )