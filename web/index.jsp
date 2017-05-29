<%-- 
    Document   : index
    Created on : 25/05/2017, 09:39:35
    Author     : kalebecalixto
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="util/css/styleCabecalho.css" type="text/css"/>
        
        
        <link rel="stylesheet" href="util/css/bootstrap.min.css" type="text/css"/>
        <link rel="stylesheet" href="componentes/font-awesome/css/font-awesome.min.css" type="text/css"/>
        
        <script src="util/js/jquery-2.2.3.min.js"></script>
        <script src="util/js/bootstrap.min.js"></script>
        
        <script defer src="util/js/cabecalho.js"></script>
        
        <title>Orçamentos Já</title>
    </head>
    <body >
        
        <div id="cabecalho" ></div>
        
        <div class="container-fluid" style="height: 50px; background: red">
            SELECT
0 as temMultMatricula,
F.codPessoa,
F.seqFuncionario,
P.nomeParaPesquisa as nome,
lpad(F.matriculaFunc,8,'0') as matricula,
F.dtAdmissao as admissao,
TSF.descrTipoSitFuncional as situacaofuncional,
F.idAtivo,
FC.codCargoFuncao as codcargo,
FC.descrcargoFuncao as descrcargo,
FRF.seqrelacaofuncional,
FRF.descrrelacaofuncional,
(SELECT CPF.numerocpf FROM bascpf CPF WHERE CPF.idAtivo = 1 AND CPF.codpessoa = P.codpessoa) as cpf,

coalesce(
(
   SELECT SUM((case when dtretorno > current_date THEN (current_date - dtafastamento)+1 ELSE FAF.qtediasdeafastamento END ))
   FROM foltipoafastamento TA
   INNER JOIN folfuncafastadosdafolha FAF ON
   FAF.codtipoafastamento = TA.codtipoafastamento
   WHERE TA.abatecontagemtempo = 1
   AND FAF.idativo = 1
   AND FAF.codpessoa = F.codpessoa
   AND FAF.codempresa = F.codempresa
   AND FAF.seqfuncionario = F.seqfuncionario
),0) as diasafastados,


coalesce(
(
   SELECT SUM((case when dtretorno > current_date THEN (current_date - dtafastamento)+1 ELSE FAF.qtediasdeafastamento END ))
   FROM foltipoafastamento TA
   INNER JOIN folfuncafastadosdafolha FAF ON
   FAF.codtipoafastamento = TA.codtipoafastamento
   WHERE TA.abatecontagemtempo = 0
   AND FAF.idativo = 1
   AND FAF.codpessoa = F.codpessoa
   AND FAF.codempresa = F.codempresa
   AND FAF.seqfuncionario = F.seqfuncionario
   AND FAF.codtipoafastamento = 67
),0) as afastamento_contribuicao,


(
SELECT BEM.descrMunicipio
FROM basNucleoDoEndereco BEN
INNER JOIN basCadastroDeEnderecos BEC ON
BEC.seqEndereco = BEN.seqEndereco
INNER JOIN basLogradouros BEL ON
BEC.seqLogradouro = BEL.seqLogradouro
INNER JOIN basTipoLogradouro BTL ON
BEL.codTipoLograd = BTL.codTipoLograd
INNER JOIN basBairro BEB ON
BEC.seqBairro = BEB.seqBairro
INNER JOIN basMunicipio BEM ON
BEB.codMunicipio = BEM.codMunicipio
WHERE BEN.seqDoNucleoDoEndereco =
(select seqDoNucleoDoEndereco
from basenderecosdapessoa
where codpessoa = (SELECT codPessoa FROM segempresa WHERE codEmpresa = 1) limit 1)
limit 1) as nomeMunicipio,

coalesce((
select R.dtafastamento
from folfuncrescisaocontratual R
where R.codpessoa = F.codpessoa
and R.codempresa = F.codempresa
and R.seqfuncionario = F.seqfuncionario
and R.dtafastamento is not null
and R.idativo = 1
and R.dtreintegracao is null limit 1
),F.dtvencimentocontrato) as dtDemissao,

(
select
FC2.codCargoFuncao||' - '||FC2.descrcargoFuncao

from folFuncCargoFuncao FFC2
LEFT JOIN folCargoFuncao FC2 ON
FC2.codempresa = FFC2.i_codempresa
AND FC2.seqcargofuncao = FFC2.seqcargofuncao
where
F.codpessoa = FFC2.codpessoa
AND F.codempresa = FFC2.codempresa
AND F.seqfuncionario = FFC2.seqfuncionario
AND FFC2.dtsuspensao is not null
AND FFC2.idativo = 1
order by dtsuspensao desc limit 1
) as cargo_1

FROM folFuncionarios F
INNER JOIN folRelacaoFuncional FRF ON
F.seqrelacaofuncional = FRF.seqrelacaofuncional
LEFT JOIN folFuncCargoFuncao FFC ON
F.i_codpessoa = FFC.codpessoa
AND F.i_codempresa = FFC.codempresa
AND F.i_seqfuncionario = FFC.seqfuncionario
AND F.seqfunccargo = FFC.seqfunccargo
LEFT JOIN folCargoFuncao FC ON
FC.codempresa = FFC.i_codempresa
AND FC.seqcargofuncao = FFC.seqcargofuncao
INNER JOIN basPessoas P ON
F.codPessoa = P.codPessoa
INNER JOIN foltiposituacfuncional TSF ON
TSF.seqTipoSitFuncional = F.seqTipoSitFuncional
WHERE F.codPessoa = 528077
AND F.matriculafunc in (1096539,1096539,1096539,1096539,1096539,1096539,1096539,1096539,1096539,1096539)
and F.dtadmissao in (select MAX(dtadmissao) from folfuncionarios where matriculafunc in (1096539,1096539,1096539,1096539,1096539,1096539,1096539,1096539,1096539,1096539) group by matriculafunc)
ORDER BY seqFuncionario, matricula
 http-bio-8080-exec-35 WARN  fonts.FontUtil - Font 'Arial' is not available to the JVM. For more details, see http://jasperreports.sourceforge.net/api/net/sf/jasperreports/engine/util/JRFontNotFoundException.html
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT FU.codFuncao,
FU.descrFuncao,
TTA.codCaractDaFuncao,
TTA.descrCaractDaFuncao,
FTA.dtInicial,
FTA.dtFinal,
P1.codpessoa as codEmpregador,
P1.nomerazaosocial as nomeEmpregador,
P2.codpessoa as codPrev,
P2.nomerazaosocial as nomePrev,
TDTA1.siglaTipoDocTempoAnter as siglaTipoDoc,
TDTA1.descrTipoDocTempoAnter as descrTipoDoc,
FTA.dtDocumento,
FTA.numDocumento as numDocumento,
FTA.idUtilizaParaAdicionais,
FTA.idAverbado,
FTA.idServidorPublico,
FTA.dtAverbacao,
FTA.numDocumentoAverba,
TDTA2.siglaTipoDocTempoAnter as siglaTipoDocAverba,
TDTA2.descrTipoDocTempoAnter as descrTipoDocAverba,
FTA.qteDiasFaltas,
FTA.totalLiquidoDeDias,
FTA.observacoes,
FTA.seqTempoServico,
FTA.totalliquidodedias
FROM folFuncTemposDeServicos FTA
INNER JOIN folFuncoes FU ON
FTA.seqFuncao = FU.seqFuncao
LEFT JOIN folTipoTempoAnter TTA ON
FTA.codCaractDaFuncao = TTA.codCaractDaFuncao
LEFT JOIN basPessoas P1 ON
FTA.i_codpessoa = P1.codpessoa
LEFT JOIN basPessoas P2 ON
FTA.j_codpessoa = P2.codpessoa
INNER JOIN foltipodoctempoanter TDTA1 ON
FTA.idtipodoctempoanter = TDTA1.idtipodoctempoanter
LEFT JOIN foltipodoctempoanter TDTA2 ON
FTA.i_idtipodoctempoanter = TDTA2.idtipodoctempoanter
INNER JOIN folfuncionarios F ON
F.codpessoa = FTA.codpessoa
and F.codempresa = FTA.codempresa
and F.seqfuncionario = FTA.seqfuncionario
WHERE FTA.idativo = 1

AND F.matriculafunc = 01096539

AND TTA.codCaractDaFuncao IN ( 'TC', 'CC', 'TA' )
AND ( FTA.seqtemposervico in (0) OR '(0)' = '(0)')
ORDER BY FTA.dtInicial, FTA.dtFinal
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT FU.codFuncao,
FU.descrFuncao,
TTA.codCaractDaFuncao,
TTA.descrCaractDaFuncao,
FTA.dtInicial,
FTA.dtFinal,
P1.codpessoa as codEmpregador,
P1.nomerazaosocial as nomeEmpregador,
P2.codpessoa as codPrev,
P2.nomerazaosocial as nomePrev,
TDTA1.siglaTipoDocTempoAnter as siglaTipoDoc,
TDTA1.descrTipoDocTempoAnter as descrTipoDoc,
FTA.dtDocumento,
FTA.numDocumento as numDocumento,
FTA.idUtilizaParaAdicionais,
FTA.idAverbado,
FTA.idServidorPublico,
FTA.dtAverbacao,
FTA.numDocumentoAverba,
TDTA2.siglaTipoDocTempoAnter as siglaTipoDocAverba,
TDTA2.descrTipoDocTempoAnter as descrTipoDocAverba,
FTA.qteDiasFaltas,
FTA.totalLiquidoDeDias,
FTA.observacoes,
FTA.seqTempoServico,
FTA.totalliquidodedias
FROM folFuncTemposDeServicos FTA
INNER JOIN folFuncoes FU ON
FTA.seqFuncao = FU.seqFuncao
LEFT JOIN folTipoTempoAnter TTA ON
FTA.codCaractDaFuncao = TTA.codCaractDaFuncao
LEFT JOIN basPessoas P1 ON
FTA.i_codpessoa = P1.codpessoa
LEFT JOIN basPessoas P2 ON
FTA.j_codpessoa = P2.codpessoa
INNER JOIN foltipodoctempoanter TDTA1 ON
FTA.idtipodoctempoanter = TDTA1.idtipodoctempoanter
LEFT JOIN foltipodoctempoanter TDTA2 ON
FTA.i_idtipodoctempoanter = TDTA2.idtipodoctempoanter
INNER JOIN folfuncionarios F ON
F.codpessoa = FTA.codpessoa
and F.codempresa = FTA.codempresa
and F.seqfuncionario = FTA.seqfuncionario
WHERE FTA.idativo = 1

AND F.matriculafunc = 01096539

AND TTA.codCaractDaFuncao IN ( 'TC', 'CC', 'TA' )
AND ( FTA.seqtemposervico in (0,100,101,102) OR '(0,100,101,102)' = '(0)')
ORDER BY FTA.dtInicial, FTA.dtFinal
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT
FCF.idativo,
CF.codcargofuncao,
CF.descrcargofuncao,
FCF.dtIniciocargofuncao,
FCF.dtSuspensao,
FCF.dtFim,
(CASE WHEN FCF.dtfim IS NOT NULL THEN FCF.dtfim WHEN ( FCF.dtSuspensao IS NULL AND FCF.dtfim IS NULL) THEN CURRENT_DATE ELSE FCF.dtSuspensao END) as dtFinal,
siglaTipoRegPrevid,
descrquadroFuncional,
(SELECT cast(((CASE WHEN FCF2.dtfim IS NOT NULL THEN FCF2.dtfim WHEN ( FCF2.dtSuspensao IS NULL AND FCF2.dtfim IS NULL) THEN Coalesce((select dtafastamento from folfuncrescisaocontratual where codpessoa = F.codpessoa and seqfuncionario = F.seqfuncionario and codempresa = F.codempresa and idativo=1 order by dtafastamento desc limit 1), CURRENT_DATE) ELSE FCF2.dtSuspensao END)-FCF2.dtIniciocargofuncao) as bigint)  from folfunccargofuncao FCF2 where FCF2.codpessoa = FCF.codpessoa and FCF2.seqfuncionario = FCF.seqfuncionario and FCF2.seqfunccargo = FCF.seqfunccargo) as qteDias,

(
	select B.nomerazaosocial from baspessoas B where codpessoa in (select codpessoa from segEmpresa)
)
as empresaContratante,

cast((
  (
  CASE
  WHEN (FCF.dtIniciocargofuncao = ( select
  FCF2.dtIniciocargofuncao
  from folfunccargofuncao FCF2
  where FCF2.seqfuncionario = FCF.seqfuncionario
  and FCF2.codpessoa = FCF.codpessoa
  and FCF2.codempresa = FCF.codempresa
  and FCF2.idativo = 1
  order by FCF2.dtIniciocargofuncao
  LIMIT 1
  )
  AND
  (
   select COUNT(*)
   from folfunccargofuncao FCF2
   where FCF2.seqfuncionario = FCF.seqfuncionario
   and FCF2.codpessoa = FCF.codpessoa
   and FCF2.codempresa = FCF.codempresa
   and FCF2.idativo = 1
  ) > 1)
  THEN
  ((
  select
  FCF2.dtIniciocargofuncao
  from folfunccargofuncao FCF2
  where FCF2.seqfuncionario = FCF.seqfuncionario
  and FCF2.codpessoa = FCF.codpessoa
  and FCF2.codempresa = FCF.codempresa
  and FCF2.idativo = 1
  order by FCF2.dtIniciocargofuncao DESC
  LIMIT 1
  ) - FCF.dtIniciocargofuncao )
  -

(
  SELECT
  coalesce(SUM
  (
  cast(((CASE WHEN FCF2.dtfim IS NOT NULL THEN FCF2.dtfim WHEN ( FCF2.dtSuspensao IS NULL AND FCF2.dtfim IS NULL) THEN CURRENT_DATE ELSE FCF2.dtSuspensao END)-FCF2.dtIniciocargofuncao) as bigint)
  ), 0) as totaldesconsiderar
  from folfunccargofuncao FCF2
  where FCF2.codpessoa = FCF.codpessoa
  and FCF2.seqfuncionario = FCF.seqfuncionario
  and FCF2.idativo = 1
  and FCF2.dtIniciocargofuncao not in ((select
  FCF3.dtIniciocargofuncao
  from folfunccargofuncao FCF3
  where FCF3.seqfuncionario = FCF.seqfuncionario
  and FCF3.codpessoa = FCF.codpessoa
  and FCF3.codempresa = FCF.codempresa
  and FCF3.idativo = 1
  order by FCF3.dtIniciocargofuncao
  LIMIT 1
  ), (select
  FCF3.dtIniciocargofuncao
  from folfunccargofuncao FCF3
  where FCF3.seqfuncionario = FCF.seqfuncionario
  and FCF3.codpessoa = FCF.codpessoa
  and FCF3.codempresa = FCF.codempresa
  and FCF3.idativo = 1
  order by FCF3.dtIniciocargofuncao desc
  LIMIT 1
  )) order by totaldesconsiderar LIMIT 1
  )


  ELSE
  (SELECT cast(((CASE WHEN FCF2.dtfim IS NOT NULL THEN FCF2.dtfim WHEN ( FCF2.dtSuspensao IS NULL AND FCF2.dtfim IS NULL) THEN CURRENT_DATE ELSE FCF2.dtSuspensao END)-FCF2.dtIniciocargofuncao) as bigint)  from folfunccargofuncao FCF2 where FCF2.codpessoa = FCF.codpessoa and FCF2.seqfuncionario = FCF.seqfuncionario and FCF2.seqfunccargo = FCF.seqfunccargo )
  END
)
) as bigint) as qteDias_old,


coalesce((CASE WHEN (
  FCF.dtiniciocargofuncao
  -
  (
	select
	coalesce(FCF2.dtsuspensao, FCF2.dtfim)
	from folfunccargofuncao FCF2
	where FCF2.codpessoa = FCF.codpessoa
	and FCF2.seqfuncionario = FCF.seqfuncionario
	and FCF2.dtiniciocargofuncao <  FCF.dtiniciocargofuncao
	and FCF2.idativo = 1
	AND ( FCF2.seqfunccargo in (0,3,4,5) OR '(0,3,4,5)' = '(0)')
	ORDER BY FCF2.dtiniciocargofuncao desc
	LIMIT 1

 )
) > 0 THEN 0
else
(
  FCF.dtiniciocargofuncao
  -
  (
	select
	coalesce(FCF2.dtsuspensao, FCF2.dtfim)
	from folfunccargofuncao FCF2
	where FCF2.codpessoa = FCF.codpessoa
	and FCF2.seqfuncionario = FCF.seqfuncionario
	and FCF2.dtiniciocargofuncao <  FCF.dtiniciocargofuncao
	and FCF2.idativo = 1
	AND ( FCF2.seqfunccargo in (0,3,4,5) OR '(0,3,4,5)' = '(0)')
	ORDER BY FCF2.dtiniciocargofuncao desc
	LIMIT 1

 )
-- ) +1*-1 END), 0) as qtediasintercalado
) END), 0) as qtediasintercalado

from folfuncionarios F
INNER JOIN folfunccargofuncao FCF ON
FCF.codpessoa = F.codpessoa
AND FCF.codempresa = F.codempresa
AND FCF.seqfuncionario = F.seqfuncionario
INNER JOIN folcargofuncao CF ON
CF.codempresa = FCF.codempresa
AND CF.seqcargofuncao = FCF.seqcargofuncao
LEFT JOIN folfuncregimeprevidencia PREV ON
PREV.codpessoa = F.codpessoa
AND PREV.codempresa = F.codempresa
AND PREV.seqfuncionario = F.seqfuncionario
AND PREV.idAtivo = 1
AND PREV.dtfim is null
LEFT JOIN foltiporegimeprevidenciario TPREV ON
TPREV.seqTiporegprevid = PREV.seqTiporegprevid
LEFT JOIN folquadrofuncionaldecargos QFC ON
QFC.codquadrofuncional = FCF.codquadrofuncional
where
F.matriculafunc = 01096539

AND FCF.idativo = 1
AND FCF.idSelecionadoContTempo = 1

AND ( FCF.seqfunccargo in (0,3,4,5) OR '(0,3,4,5)' = '(0)')
ORDER BY FCF.dtIniciocargofuncao
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT
FCF.idativo,
CF.codcargofuncao,
CF.descrcargofuncao,
FCF.dtIniciocargofuncao,
FCF.dtSuspensao,
FCF.dtFim,
(CASE WHEN FCF.dtfim IS NOT NULL THEN FCF.dtfim WHEN ( FCF.dtSuspensao IS NULL AND FCF.dtfim IS NULL) THEN CURRENT_DATE ELSE FCF.dtSuspensao END) as dtFinal,
siglaTipoRegPrevid,
descrquadroFuncional,
(SELECT cast(((CASE WHEN FCF2.dtfim IS NOT NULL THEN FCF2.dtfim WHEN ( FCF2.dtSuspensao IS NULL AND FCF2.dtfim IS NULL) THEN Coalesce((select dtafastamento from folfuncrescisaocontratual where codpessoa = F.codpessoa and seqfuncionario = F.seqfuncionario and codempresa = F.codempresa and idativo=1 order by dtafastamento desc limit 1), CURRENT_DATE) ELSE FCF2.dtSuspensao END)-FCF2.dtIniciocargofuncao) as bigint)  from folfunccargofuncao FCF2 where FCF2.codpessoa = FCF.codpessoa and FCF2.seqfuncionario = FCF.seqfuncionario and FCF2.seqfunccargo = FCF.seqfunccargo) as qteDias,

(
	select B.nomerazaosocial from baspessoas B where codpessoa in (select codpessoa from segEmpresa)
)
as empresaContratante,

cast((
  (
  CASE
  WHEN (FCF.dtIniciocargofuncao = ( select
  FCF2.dtIniciocargofuncao
  from folfunccargofuncao FCF2
  where FCF2.seqfuncionario = FCF.seqfuncionario
  and FCF2.codpessoa = FCF.codpessoa
  and FCF2.codempresa = FCF.codempresa
  and FCF2.idativo = 1
  order by FCF2.dtIniciocargofuncao
  LIMIT 1
  )
  AND
  (
   select COUNT(*)
   from folfunccargofuncao FCF2
   where FCF2.seqfuncionario = FCF.seqfuncionario
   and FCF2.codpessoa = FCF.codpessoa
   and FCF2.codempresa = FCF.codempresa
   and FCF2.idativo = 1
  ) > 1)
  THEN
  ((
  select
  FCF2.dtIniciocargofuncao
  from folfunccargofuncao FCF2
  where FCF2.seqfuncionario = FCF.seqfuncionario
  and FCF2.codpessoa = FCF.codpessoa
  and FCF2.codempresa = FCF.codempresa
  and FCF2.idativo = 1
  order by FCF2.dtIniciocargofuncao DESC
  LIMIT 1
  ) - FCF.dtIniciocargofuncao )
  -

(
  SELECT
  coalesce(SUM
  (
  cast(((CASE WHEN FCF2.dtfim IS NOT NULL THEN FCF2.dtfim WHEN ( FCF2.dtSuspensao IS NULL AND FCF2.dtfim IS NULL) THEN CURRENT_DATE ELSE FCF2.dtSuspensao END)-FCF2.dtIniciocargofuncao) as bigint)
  ), 0) as totaldesconsiderar
  from folfunccargofuncao FCF2
  where FCF2.codpessoa = FCF.codpessoa
  and FCF2.seqfuncionario = FCF.seqfuncionario
  and FCF2.idativo = 1
  and FCF2.dtIniciocargofuncao not in ((select
  FCF3.dtIniciocargofuncao
  from folfunccargofuncao FCF3
  where FCF3.seqfuncionario = FCF.seqfuncionario
  and FCF3.codpessoa = FCF.codpessoa
  and FCF3.codempresa = FCF.codempresa
  and FCF3.idativo = 1
  order by FCF3.dtIniciocargofuncao
  LIMIT 1
  ), (select
  FCF3.dtIniciocargofuncao
  from folfunccargofuncao FCF3
  where FCF3.seqfuncionario = FCF.seqfuncionario
  and FCF3.codpessoa = FCF.codpessoa
  and FCF3.codempresa = FCF.codempresa
  and FCF3.idativo = 1
  order by FCF3.dtIniciocargofuncao desc
  LIMIT 1
  )) order by totaldesconsiderar LIMIT 1
  )


  ELSE
  (SELECT cast(((CASE WHEN FCF2.dtfim IS NOT NULL THEN FCF2.dtfim WHEN ( FCF2.dtSuspensao IS NULL AND FCF2.dtfim IS NULL) THEN CURRENT_DATE ELSE FCF2.dtSuspensao END)-FCF2.dtIniciocargofuncao) as bigint)  from folfunccargofuncao FCF2 where FCF2.codpessoa = FCF.codpessoa and FCF2.seqfuncionario = FCF.seqfuncionario and FCF2.seqfunccargo = FCF.seqfunccargo )
  END
)
) as bigint) as qteDias_old,


coalesce((CASE WHEN (
  FCF.dtiniciocargofuncao
  -
  (
	select
	coalesce(FCF2.dtsuspensao, FCF2.dtfim)
	from folfunccargofuncao FCF2
	where FCF2.codpessoa = FCF.codpessoa
	and FCF2.seqfuncionario = FCF.seqfuncionario
	and FCF2.dtiniciocargofuncao <  FCF.dtiniciocargofuncao
	and FCF2.idativo = 1
	AND ( FCF2.seqfunccargo in (0,18545,28552,32378,5929) OR '(0,18545,28552,32378,5929)' = '(0)')
	ORDER BY FCF2.dtiniciocargofuncao desc
	LIMIT 1

 )
) > 0 THEN 0
else
(
  FCF.dtiniciocargofuncao
  -
  (
	select
	coalesce(FCF2.dtsuspensao, FCF2.dtfim)
	from folfunccargofuncao FCF2
	where FCF2.codpessoa = FCF.codpessoa
	and FCF2.seqfuncionario = FCF.seqfuncionario
	and FCF2.dtiniciocargofuncao <  FCF.dtiniciocargofuncao
	and FCF2.idativo = 1
	AND ( FCF2.seqfunccargo in (0,18545,28552,32378,5929) OR '(0,18545,28552,32378,5929)' = '(0)')
	ORDER BY FCF2.dtiniciocargofuncao desc
	LIMIT 1

 )
-- ) +1*-1 END), 0) as qtediasintercalado
) END), 0) as qtediasintercalado

from folfuncionarios F
INNER JOIN folfunccargofuncao FCF ON
FCF.codpessoa = F.codpessoa
AND FCF.codempresa = F.codempresa
AND FCF.seqfuncionario = F.seqfuncionario
INNER JOIN folcargofuncao CF ON
CF.codempresa = FCF.codempresa
AND CF.seqcargofuncao = FCF.seqcargofuncao
LEFT JOIN folfuncregimeprevidencia PREV ON
PREV.codpessoa = F.codpessoa
AND PREV.codempresa = F.codempresa
AND PREV.seqfuncionario = F.seqfuncionario
AND PREV.idAtivo = 1
AND PREV.dtfim is null
LEFT JOIN foltiporegimeprevidenciario TPREV ON
TPREV.seqTiporegprevid = PREV.seqTiporegprevid
LEFT JOIN folquadrofuncionaldecargos QFC ON
QFC.codquadrofuncional = FCF.codquadrofuncional
where
F.matriculafunc = 01096539

AND FCF.idativo = 1
AND FCF.idSelecionadoContTempo = 1

AND ( FCF.seqfunccargo in (0,18545,28552,32378,5929) OR '(0,18545,28552,32378,5929)' = '(0)')
ORDER BY FCF.dtIniciocargofuncao
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT FFF.seqTipoFerias,
FFF.dtInicioPeriodoAquisitivo,
FFF.dtFimPeriodoAquisitivo,
CTR.dtInicioGozo, CTR.dtFimGozo,
CTR.qteDiasGozados,
CTR.qteDiasDePecunia
FROM folfuncferiasfuncionario FFF
LEFT JOIN folFuncFeriasCtrDeGozo CTR ON
FFF.seqTipoFerias = CTR.seqTipoFerias AND
FFF.codPessoa = CTR.codPessoa AND
FFF.codEmpresa = CTR.codEmpresa AND
FFF.seqFuncionario = CTR.seqFuncionario AND
CTR.seqTipoFerias = 2 AND
FFF.dtInicioPeriodoAquisitivo = CTR.dtInicioPeriodoAquisitivo
AND CTR.idAtivo = 1
WHERE FFF.seqFuncionario = 3297
AND FFF.codPessoa = 528077
AND FFF.codEmpresa = 1
AND FFF.seqTipoFerias = 2
AND FFF.idAtivo = 1
ORDER BY FFF.dtInicioPeriodoAquisitivo, CTR.dtInicioGozo
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: select
	z.*

	, (CASE WHEN (z.qtefaltasadescontar - z.qteafastado) < 0.00 THEN 0.00 ELSE (z.qtefaltasadescontar - z.qteafastado) END)
	as qteFaltas

from (
	select
		y.*

		, (
			select count(1)

			from (
				select
				x.*
				, cast(extract(year from x.dia) as integer) as ano
				, cast(extract(month from x.dia) as integer) as mes
				, x.dia

				from (
					select
						ffaf.codpessoa
						, ffaf.codempresa
						, ffaf.seqfuncionario

						, p.nomerazaosocial
						, fta.codtipoafastamento
						, fta.descrtipoafastamento
						, ffaf.dtafastamento
						, ffaf.dtretorno

						, ffaf.dtafastamento + interval '1 day' * ( generate_series(0, qtediasdeafastamento - 1) )
						as dia

					from folfuncafastadosdafolha ffaf

					join foltipoafastamento fta
					on fta.codtipoafastamento = ffaf.codtipoafastamento


					join folfuncionarios ff
					on ff.seqfuncionario = ffaf.seqfuncionario
					and ff.codpessoa = ffaf.codpessoa
					and ff.codempresa = ffaf.codempresa
					and ff.seqfuncionario = ffaf.seqfuncionario

					join baspessoas p on p.codpessoa = ff.codpessoa

					where ffaf.idativo = 1
					and ffaf.codpessoa = y.codpessoa
					and ffaf.codempresa = y.codempresa
					and ffaf.seqfuncionario = y.seqfuncionario
				) as x
			) as x

			where x.ano = y.anofalta
			and x.mes = y.mesfalta

		) as qteafastado

	from (
		SELECT
			generate_series(0, 1) as tipo
			, GC.ano
			, GC.codMes

			, case
				when codmes = 1 then
					gc.ano - 1
				else
					gc.ano
			end
			as anofalta

			, case
				when codmes = 1 then
					12
				else
					gc.codmes - 1
			end
			as mesfalta

			, coalesce((FALT.qteFaltas - coalesce(FALT.qteabonada+(Coalesce(qteabonadaconttempo,0)),0)),0) as qtefaltasadescontar
			, coalesce(qteabonada,0) as abonadas

			, FALT.codpessoa
			, FALT.codempresa
			, FALT.seqfuncionario

		FROM folFuncFreqFaltas FALT

		INNER JOIN folGerenciadorCalculo GC ON
		FALT.seqgerenciadorCalculo = GC.seqgerenciadorCalculo

		WHERE FALT.seqFuncionario = 3297

		AND FALT.codPessoa = 528077

		AND FALT.codEmpresa = 1

		AND FALT.idativo = 1

		AND FALT.sequnidadelanc = 'D'

		AND coalesce((FALT.qteFaltas - coalesce(FALT.qteabonada+(Coalesce(qteabonadaconttempo,0)),0)),0) > 0
	) as y

) as z

ORDER BY z.tipo, z.ano, z.codMes
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT date(FO.dtOcorrencia) as dtOcorrencia,
FO.Ocorrencias,
FO.seqOcorrenciaFunc,
FTO.desctipoocorrencia

FROM folFuncOcorrencias FO
INNER JOIN foltiposocorrencias FTO ON
FTO.seqtipoocorrencia = FO.seqtipoocorrencia
inner join folfuncionarios F ON
F.seqfuncionario = FO.seqfuncionario
and F.codpessoa = FO.codpessoa
and F.codempresa = FO.codempresa
WHERE FO.idAtivo = 1
AND FO.idimpcerttempo = 1
AND F.matriculafunc = 01096539

UNION

SELECT dtafastamento, 'Afastamento Data Inicio: '|| to_char(dtafastamento, 'DD/MM/YYYY') ||' Data Final: '||to_char(dtfinalafastamento, 'DD/MM/YYYY'), null, TA.descrtipoafastamento
FROM folfuncafastadosdafolha FA
inner join foltipoafastamento TA ON
TA.codtipoafastamento = FA.codtipoafastamento
inner join folfuncionarios F ON
F.seqfuncionario = FA.seqfuncionario
and F.codpessoa = FA.codpessoa
and F.codempresa = FA.codempresa

where
TA.abatecontagemtempo = 1
and FA.idativo = 1
AND F.matriculafunc = 01096539
ORDER BY dtOcorrencia
 folCERTContagTempoServ_MOD01 subreports #1 DEBUG query.JRJdbcQueryExecuter - SQL query string: SELECT date(FO.dtOcorrencia) as dtOcorrencia,
FO.Ocorrencias,
FO.seqOcorrenciaFunc,
FTO.desctipoocorrencia

FROM folFuncOcorrencias FO
INNER JOIN foltiposocorrencias FTO ON
FTO.seqtipoocorrencia = FO.seqtipoocorrencia
inner join folfuncionarios F ON
F.seqfuncionario = FO.seqfuncionario
and F.codpessoa = FO.codpessoa
and F.codempresa = FO.codempresa
WHERE FO.idAtivo = 1
AND FO.idimpcerttempo = 1
AND F.matriculafunc = 01096539

UNION

SELECT dtafastamento, 'Afastamento Data Inicio: '|| to_char(dtafastamento, 'DD/MM/YYYY') ||' Data Final: '||to_char(dtfinalafastamento, 'DD/MM/YYYY'), null, TA.descrtipoafastamento
FROM folfuncafastadosdafolha FA
inner join foltipoafastamento TA ON
TA.codtipoafastamento = FA.codtipoafastamento
inner join folfuncionarios F ON
F.seqfuncionario = FA.seqfuncionario
and F.codpessoa = FA.codpessoa
and F.codempresa = FA.codempresa

where
TA.abatecontagemtempo = 1
and FA.idativo = 1
AND F.matriculafunc = 01096539
ORDER BY dtOcorrencia

        </div>

        
        
        
        <script>
            
            
            
        </script>
    </body>
</html>
 