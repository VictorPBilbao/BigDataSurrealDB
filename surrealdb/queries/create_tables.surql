LET $locations = (SELECT regiao, estado, municipio, bairro, rua, numero, cep FROM Dataset GROUP BY regiao, estado, municipio, bairro, rua, numero);
FOR $location IN $locations {
	CREATE Endereco SET 
        id = [
    		$location.regiao,
    		$location.estado,
    		$location.municipio,
    		$location.bairro,
    		$location.rua,
    		$location.numero
    	],
        cep = $location.cep,
        regiao = $location.regiao,
        estado = $location.estado,
        municipio = $location.municipio,
        bairro = $location.bairro,
        rua = $location.rua,
        numero = $location.numero
};


LET $stations = SELECT bandeira, revenda, cnpj, regiao, estado, municipio, bairro, rua, numero FROM Dataset GROUP BY bandeira, revenda, cnpj;
FOR $station IN $stations {
    CREATE Posto SET
        id = [
            Endereco:[
                $station.regiao,
        		$station.estado,
        		$station.municipio,
        		$station.bairro,
        		$station.rua,
        		$station.numero                
            ],
            $station.bandeira,
            $station.revenda,
            $station.cnpj,
        ],
        endereco = Endereco:[
            $station.regiao,
            $station.estado,
            $station.municipio,
            $station.bairro,
            $station.rua,
            $station.numero
        ],
        bandeira = $station.bandeira,
        revenda = $station.revenda,
        cnpj = $station.cnpj
}


LET $measurements = select * from Dataset;
FOR $measurement IN $measurements {
    UPSERT Medida SET
        compra = $measurement.compra,
        venda = $measurement.venda,
        medida = $measurement.medida,
        id = [
            $measurement.produto,
            Posto:[
                Endereco:[
                    $measurement.regiao,
                    $measurement.estado,
                    $measurement.municipio,
                    $measurement.bairro,
                    $measurement.rua,
                    $measurement.numero
                ],
                $measurement.bandeira,
                $measurement.revenda,
                $measurement.cnpj,
            ],
            $measurement.datacoleta,
        ],
            produto = $measurement.produto,
            posto = Posto:[
                Endereco:[
                    $measurement.regiao,
                    $measurement.estado,
                    $measurement.municipio,
                    $measurement.bairro,
                    $measurement.rua,
                    $measurement.numero
                ],
                $measurement.bandeira,
                $measurement.revenda,
                $measurement.cnpj,
            ],
            datacoleta = $measurement.datacoleta
}