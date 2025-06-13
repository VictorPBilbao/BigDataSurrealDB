-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- TABLE: Dataset
-- ------------------------------

DEFINE TABLE Dataset TYPE NORMAL SCHEMALESS PERMISSIONS NONE;

DEFINE FIELD cnpj ON Dataset TYPE string VALUE $value.trim() PERMISSIONS FULL;
DEFINE FIELD compra ON Dataset TYPE number | string VALUE <number> ('0' + $value.replace(',', '.')) PERMISSIONS FULL;
DEFINE FIELD datacoleta ON Dataset TYPE datetime | string VALUE <datetime> ($value.split('/')[2] + '-' + $value.split('/')[1] + '-' + $value.split('/')[0]) PERMISSIONS FULL;
DEFINE FIELD venda ON Dataset TYPE number | string VALUE <number> ($value.replace(',', '.')) PERMISSIONS FULL;



-- ------------------------------
-- TABLE: GasStation
-- ------------------------------

DEFINE TABLE GasStation TYPE NORMAL SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD id ON GasStation TYPE array<record<Location> | string> PERMISSIONS FULL;
DEFINE FIELD id[*] ON GasStation TYPE record<Location> | string PERMISSIONS FULL;



-- ------------------------------
-- TABLE: Location
-- ------------------------------

DEFINE TABLE Location TYPE ANY SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD cep ON Location TYPE string PERMISSIONS FULL;
DEFINE FIELD id ON Location TYPE array<string> PERMISSIONS FULL;
DEFINE FIELD id[*] ON Location TYPE string PERMISSIONS FULL;



-- ------------------------------
-- TABLE: Measurement
-- ------------------------------

DEFINE TABLE Measurement TYPE ANY SCHEMAFULL PERMISSIONS NONE;

DEFINE FIELD compra ON Measurement TYPE number PERMISSIONS FULL;
DEFINE FIELD id ON Measurement TYPE array<record<GasStation> | string | datetime> PERMISSIONS FULL;
DEFINE FIELD id[*] ON Measurement TYPE record<GasStation> | string | datetime PERMISSIONS FULL;
DEFINE FIELD medida ON Measurement TYPE string PERMISSIONS FULL;
DEFINE FIELD venda ON Measurement TYPE number PERMISSIONS FULL;



