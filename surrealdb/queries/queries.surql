-- Aqui vamos criar as tabelas e sas relações, com base na tabela Dataset

-- Create Locations
LET $locations = (SELECT regiao, estado, municipio, bairro, rua, numero, cep FROM Dataset GROUP BY regiao, estado, municipio, bairro, rua, numero);
FOR $location IN $locations {
	CREATE Location SET 
        cep = $location.cep, 
        id = [
    		$location.regiao,
    		$location.estado,
    		$location.municipio,
    		$location.bairro,
    		$location.rua,
    		$location.numero
    	];
};

-- Create GasStations
LET $stations = SELECT bandeira, revenda, cnpj, regiao, estado, municipio, bairro, rua, numero FROM Dataset GROUP BY bandeira, revenda, cnpj;
FOR $station IN $stations {
    CREATE GasStation SET
        id = [
            $station.bandeira,
            Location:[
                $station.regiao,
        		$station.estado,
        		$station.municipio,
        		$station.bairro,
        		$station.rua,
        		$station.numero                
            ],
            $station.revenda,
            $station.cnpj,
        ]
};

-- Create Measurements
LET $measurements = select * from Dataset;
FOR $measurement IN $measurements {
    CREATE Measurement SET
        compra = $measurement.compra,
        venda = $measurement.venda,
        medida = $measurement.medida,
        id = [
            $measurement.produto,
            GasStation:[
                $measurement.bandeira,
                Location:[
                    $measurement.regiao,
            		$measurement.estado,
            		$measurement.municipio,
            		$measurement.bairro,
            		$measurement.rua,
            		$measurement.numero                
                ],
                $measurement.revenda,
                $measurement.cnpj,
            ],
            $measurement.datacoleta,
        ]
}