#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//------------------------------------------------------------------------------
/*{Protheus.doc} ADV004
Rotina para montagem da tela de chamados de axCadastro

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADV004()
/*
AxCadastro("ZZD","Cadastro de Chamados")
//{"Incluir","AXINCLUI",0,3},; somente axInclui
Private aRotina   := {{"Pesquisar","AXPESQUI",0,1},;
						{"Visualizar","AXVISUAL",0,2},;
						{"Incluir","AXINCLUI",0,3},;
						{"Alterar","AXALTERA",0,4},;
						{"Excluir","AXDELETA",0,5},;
						{"Legenda","U_ADVLEG()",0,6}}

*/
Private cCadastro := "Chamados"
Private aRotina   := {{"Pesquisar","AXPESQUI",0,1},;
						{"Visualizar","AXVISUAL",0,2},;
						{"Incluir","U_ADVINC",0,3},;
						{"Alterar","U_ADVALT",0,4},;
						{"Excluir","U_ADVEXC",0,5},;
						{"Legenda","U_ADVLEG()",0,6}}


Private aCores	:= {{ "ZZD->ZZD_STATUS = '1' .OR. Empty(ZZD->ZZD_STATUS) ","BR_VERDE"},;
						{ "ZZD->ZZD_STATUS = '2' ","BR_AZUL"},;
						{ "ZZD->ZZD_STATUS = '3' ","BR_AMARELO"},;
						{ "ZZD->ZZD_STATUS = '4' ","BR_PRETO"},;
						{ "ZZD->ZZD_STATUS = '5' ","BR_VERMELHO"}}
										 												
mBrowse(6,1,22,75,"ZZD",,,,,,aCores)

Return


//------------------------------------------------------------------------------
/*{Protheus.doc} ADVLEG
Legenda dos chamados

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADVLEG()

local aLegenda :={{"BR_VERDE","Chamado em Aberto"},;     
				   {"BR_AZUL","Chamado em Atendimento"},;
				   {"BR_AMARELO","Chamado Aguardando Usuario"},; 
				   {"BR_PRETO","Chamado Encerrado"},;
				   {"BR_VERMELHO","Chamado em Atraso"}}
				   
BrwLegenda(cCadastro,"Legenda",aLegenda)

Return()

//------------------------------------------------------------------------------
/*{Protheus.doc} ADVINC
Validação de Inclusão

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADVINC(cAlias,nReg,nOpc)

Local lok			:= .t.
Local nOpca 		:= 0
Local _aCposNZZD    := {} 
Local aCposZZD      := {}
Local cCodigo
Local cModulo 
Local cObs    
Local Dtemis  
Local cUse    
Local cPrior

//carrega os campos do dicionario de dados - cria as variaveis de memoria 
sx3->(dbsetorder(1))
If sx3->(dbseek("ZZD"))
	while sx3->(!eof()) .and. sx3->x3_arquivo=="ZZD" 
		if  X3USO(sx3->x3_usado).and. cNivel >= sx3->x3_nivel .and.;
			ascan(_aCposNZZD, {|x| x==alltrim(sx3->x3_campo)})=0  
		   aadd(aCposZZD,sx3->x3_campo)
        endif
        sx3->(dbskip())
    enddo
endif 

if lok  
	       //AxInclui( <cAlias>, <nReg>, <nOpc>, <aAcho>, <cFunc>, <aCpos>, <cTudoOk>, <lF3>, <cTransact>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>) 
	nOpca := Axinclui(   cAlias,   nReg,   nOpc,aCposZZD,        ,aCposZZD, "U_VALINC()" )
endif


Return()

//------------------------------------------------------------------------------
/*{Protheus.doc} VALINC
Validação de Inclusão

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User function VALINC()

Local lValInc := .T.
Local cCodTec:= ""
//Local lPodeAt:= .F. // atendente com skill para o chamado 

//validações da rotina

//verificar campo tipo de chamado
If empty(M->ZZD_TIPO)
	MsgStop("Informar tipo de atendimento","STOP")
	lValInc:= .F.
Endif 

//verificar campo descrição do chamado
If empty(M->ZZD_DESCR)
	MsgStop("Informar descrição do chamado","STOP")
	lValInc:= .F.
Endif 
 
//verificar campo data de abertura do chamado
If empty(M->ZZD_DATA)
	MsgStop("Informar data de abertura do chamado","STOP")
	lValInc:= .F.
Endif 

//advpl para ninja validação
//atendente M->ZZD_TECNIC
//tipo chamado M->ZZD_TIPO
//nivel de atendimento M->ZZD_PRIORI
//verificar se atendente pode atender o tipo de chamado
//primeira validação se ele pode atender o tipo de chamado
cCodtec := Posicione("ZZE",1,xFilial("ZZE")+M->ZZD_TECNIC+M->ZZD_TIPO,"ZZE_CODTEC")
If !Empty(M->ZZD_TECNIC) // não validar se técnico ainda não preenchido
	If  empty(cCodTec)
		MsgStop("Atendente não pode atender este tipo de chamado","STOP")
		lValInc:= .F.
	Endif
Endif

//segunda validação: se ele pode atender o tipo de SLA
cCodtec := Posicione("ZZF",1,xFilial("ZZF")+M->ZZD_TECNIC+M->ZZD_PRIORI,"ZZF_CODTEC")
If !Empty(M->ZZD_TECNIC) // não validar se técnico ainda não preenchido
	If  lValInc .AND. empty(cCodTec)
		MsgStop("Atendente não pode atender este SLA","STOP")
		lValInc:= .F.
	Endif
Endif

Return lValInc

//------------------------------------------------------------------------------
/*{Protheus.doc} ADVALT
Validação de alteração

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADVALT(cAlias,nReg,nOpc)

Local lok			:= .t.
Local nOpca 		:= 0
Local _aCposNZZD    := {} 
Local aCposZZD      := {}
Local cCodigo
Local cModulo 
Local cObs    
Local Dtemis  
Local cUse    
Local cPrior

//carrega os campos do dicionario de dados - cria as variaveis de memoria 
sx3->(dbsetorder(1))
If sx3->(dbseek("ZZD"))
	while sx3->(!eof()) .and. sx3->x3_arquivo=="ZZD" 
		if  X3USO(sx3->x3_usado).and. cNivel >= sx3->x3_nivel .and.;
			ascan(_aCposNZZD, {|x| x==alltrim(sx3->x3_campo)})=0  
		   aadd(aCposZZD,sx3->x3_campo)
        endif
        sx3->(dbskip())
    enddo
endif 

if lok  
	       //AxAltera( <cAlias>, <nReg>, <nOpc>, <aAcho>, <aCpos> , <nColMens>, <cMensagem>, <cTudoOk>  , <cTransact>, <cFunc>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>) 
	nOpca := AxAltera(   cAlias,   nReg,   nOpc,aCposZZD, aCposZZD,           ,            ,"U_VALALT()")
endif

Return()

//------------------------------------------------------------------------------
/*{Protheus.doc} VALALT
Validação de alteração

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User function VALALT()

Local lValAlt := .T.
Local cCodTec := "" //posiciona no atendente /  técnico
//validações da rotina

//verificar se tem técnico preenchido
If !Empty(ZZD_TECNIC) .AND. (M->ZZD_TECNIC <> ZZD_TECNIC)
	MsgStop("Não pode alterar chamado se tem técnico atendendo","STOP")
	lValAlt:= .F.
Endif

//advpl para ninja validação
//atendente M->ZZD_TECNIC
//tipo chamado M->ZZD_TIPO

// se tiver técnico preenchido tem que informar tipo de chamado e prioridade
If !Empty(M->ZZD_TECNIC) .AND. (M->ZZD_TECNIC <> ZZD_TECNIC) 
	If lValAlt .AND. (Empty(M->ZZD_TIPO) .OR. Empty(M->ZZD_PRIORI)) 
		MsgStop("Favor informar Tipo de chamado / SLA","STOP")
		lValAlt:= .F.
	Endif
Endif

//nivel de atendimento M->ZZD_PRIORI
//verificar se atendente pode atender o tipo de chamado
//primeira validação se ele pode atender o tipo de chamado

cCodtec := Posicione("ZZE",1,xFilial("ZZE")+M->ZZD_TECNIC+M->ZZD_TIPO,"ZZE_CODTEC")
//verificar campo tipo de chamado
//If lValAlt .AND. ((M->ZZD_TIPO <> ZZD_TIPO) .AND. !Empty(M->ZZD_TECNIC))
If !Empty(M->ZZD_TECNIC) .AND. (M->ZZD_TECNIC <> ZZD_TECNIC)// se não tiver técnico informado não tem como validar
	If  lValAlt .AND. empty(cCodTec) 
		MsgStop("Atendente não pode atender este tipo de chamado","STOP")
		lValAlt:= .F.
	Endif
Endif

//segunda validação: se ele pode atender o tipo de SLA
cCodtec := Posicione("ZZF",1,xFilial("ZZF")+M->ZZD_TECNIC+M->ZZD_PRIORI,"ZZF_CODTEC")

If !Empty(M->ZZD_TECNIC) .AND. (M->ZZD_TECNIC <> ZZD_TECNIC)// se não tiver técnico informado não tem como validar
	If  lValAlt .AND. empty(cCodTec) 
		MsgStop("Atendente não pode atender este SLA","STOP")
		lValAlt:= .F.
	Endif
Endif

Return lValAlt

//------------------------------------------------------------------------------
/*{Protheus.doc} ADVEXC
Validação de Exclusão

@author 	Rogerio Onishi Candisani
@version 	P12
@since   	
*/
//------------------------------------------------------------------------------
User Function ADVEXC(cAlias,nReg,nOpc)

Local lok			:= .t.
Local nOpca 		:= 0
Local _aCposNZZD    := {} 
Local aCposZZD      := {}
Local cCodigo
Local cModulo 
Local cObs    
Local Dtemis  
Local cUse    
Local cPrior
Local lRet:= .T.

//carrega os campos do dicionario de dados - cria as variaveis de memoria 
sx3->(dbsetorder(1))
If sx3->(dbseek("ZZD"))
	while sx3->(!eof()) .and. sx3->x3_arquivo=="ZZD" 
		if  X3USO(sx3->x3_usado).and. cNivel >= sx3->x3_nivel .and.;
			ascan(_aCposNZZD, {|x| x==alltrim(sx3->x3_campo)})=0  
		   aadd(aCposZZD,sx3->x3_campo)
        endif
        sx3->(dbskip())
    enddo
endif 

//validar se pode excluir registro
If ! Empty(ZZD_TECNIC)
	MsgStop("Não pode excluir chamado já em andamento","STOP")
	lok := .F.
	lRet:= .F.
Endif	
 
if lok  
	nOpca := AxDeleta(   cAlias,   nReg,   nOpc)
endif

Return lRet
