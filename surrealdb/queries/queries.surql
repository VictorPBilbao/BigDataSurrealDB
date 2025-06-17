-- Qual o preço médio de venda da Gasolina Comum da bandeira Ipiranga na cidade de Sao Paulo por mês, desde 2020?

-- media: 58.16s
SELECT 
    datacoleta.year() as ano, 
    datacoleta.month() as mes, 
    math::mean(venda) as media,
    municipio,
    bandeira,
    produto
FROM Dataset
WHERE 
    produto = 'GASOLINA' AND 
    bandeira = 'IPIRANGA' AND 
    municipio = 'SAO PAULO' 
GROUP BY ano, mes;

-- media: 100.05s pois precisa ficar consultando outras tabelas
SELECT datacoleta.year() AS ano,
    datacoleta.month() AS mes,
    math::mean(venda) AS media,
    posto.endereco.municipio AS municipio,
    posto.bandeira AS bandeira
FROM Medida 
WHERE 
    produto = 'GASOLINA' AND 
    posto.endereco.municipio = 'SAO PAULO' AND 
    posto.bandeira = 'IPIRANGA'
GROUP BY ano, mes;

-- media: 1.33s, usando os recordIds
SELECT 
    datacoleta.year() AS ano,
    datacoleta.month() AS mes,
    math::mean(venda) as media,
    id[1].id()[0].id()[2] AS municipio,
    id[1].id()[1] AS bandeira,
    produto
FROM Medida:['GASOLINA', Posto:[Endereco:['SE', 'SP', 'SAO PAULO', NONE, NONE, NONE], NONE, NONE, NONE], NONE]..=['GASOLINA', Posto:[Endereco:['SE', 'SP', 'SAO PAULO', .., .., ..], .., .., ..], ..] 
WHERE id[1].id()[1] = 'IPIRANGA' 
GROUP BY ano, mes;

--

-- Quais os 5 municípios do Brasil com o maior e menor preço médio de venda do Óleo Diesel S10 no último semestre registrado

-- media: 10.37s
LET $preco_cidades = SELECT * FROM (
    SELECT 
        datacoleta.year() as ano, 
        posto.endereco.municipio as municipio,
        math::mean(venda) as media
    FROM Medida:['DIESEL', NONE, NONE, NONE, NONE]..=['DIESEL', .., .., .., ..]
    WHERE 
        datacoleta >= d"2024-06-01"
    GROUP BY municipio
) ORDER BY media;
LET $len_cidades = $preco_cidades.len();
RETURN $preco_cidades[0..5];
RETURN $preco_cidades[($len_cidades-5)..$len_cidades];

--

-- Listar todas as coletas de preço em que o valor de venda da Gasolina Aditivada foi superior a média e o valor de compra (se disponível) foi inferior a média de compra, no país, no último ano.

LET $media = SELECT math::mean(venda) as venda FROM ONLY Medida:['GASOLINA ADITIVADA', NONE, NONE]..=['GASOLINA ADITIVADA', .., ..] WHERE datacoleta >= time::now() - 1y GROUP ALL;
SELECT * FROM Medida:['GASOLINA ADITIVADA', NONE, NONE]..=['GASOLINA ADITIVADA', .., ..] WHERE venda < $media;

--

-- Listar todas as bandeiras distintas que possuem revendas no estado do Rio de Janeiro (RJ)

-- media: 62s ( pois teve que scanear todas as linhas )
SELECT bandeira FROM Dataset WHERE estado = 'RJ' GROUP BY bandeira;

-- media: 1.42s ( escaneou todos os enderecos dos postos )
SELECT bandeira FROM Posto WHERE endereco.estado = 'RJ' GROUP BY bandeira;

-- media: 39ms ( escaneou somente os postos do RJ )
SELECT bandeira FROM Posto:[Endereco:['SE', 'RJ', NONE, NONE, NONE, NONE], NONE, NONE, NONE]..=[Endereco:['SE', 'RJ', .., .., .., ..], .., .., ..] GROUP BY bandeira;
