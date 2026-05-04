# TPC-DS Implementation for `Star Schema vs Snowflake Schema`

This package gives you a practical, reproducible PostgreSQL implementation of a **TPC-DS-based benchmark** for comparing **Star Schema** and **Snowflake Schema** on analytical workloads.

## What is included

- `01_build_tpcds_tools.sh` — helper script to compile `dsdgen` from the official TPC-DS kit
- `02_generate_tpcds_data.sh` — generates TPC-DS flat files (CSV-like `.dat`) for a chosen scale factor
- `03_create_raw_tpcds_tables.sql` — creates a **subset** of raw TPC-DS tables required for this study
- `04_load_raw_tpcds_data.sql` — `COPY` commands to load generated data into PostgreSQL staging tables
- `05_build_star_schema_from_tpcds.sql` — creates and loads the denormalized star schema
- `06_build_snowflake_schema_from_tpcds.sql` — creates and loads the normalized snowflake schema
- `07_benchmark_queries_tpcds.sql` — paired analytical queries for both schemas
- `08_collect_metrics.sql` — helper SQL to inspect storage footprint and row counts
- `09_run_benchmark.sh` — optional shell script to automate repeated `EXPLAIN (ANALYZE, BUFFERS)` runs

## Recommended scale factors

For a master's assignment, use:

- `SF=1` for debugging / pilot runs
- `SF=10` for the main experiment if hardware permits

TPC-DS can generate many tables, but this package uses a **focused subset** that is enough to support a strong paper while keeping implementation manageable.

## Raw TPC-DS tables used

- `date_dim`
- `customer`
- `customer_address`
- `customer_demographics`
- `item`
- `store`
- `store_sales`

## Suggested execution order

1. Build `dsdgen`
2. Generate data files
3. Create raw tables
4. Load raw data
5. Build the star schema
6. Build the snowflake schema
7. Run the benchmark queries with cold/warm repetitions
8. Collect latency, storage, and scaling results

## Example workflow

```bash
bash 01_build_tpcds_tools.sh
bash 02_generate_tpcds_data.sh 1 /path/to/tpcds-kit/tools /path/to/output
psql -U postgres -d dwbench -f 03_create_raw_tpcds_tables.sql
psql -U postgres -d dwbench -v data_dir="/path/to/output" -f 04_load_raw_tpcds_data.sql
psql -U postgres -d dwbench -f 05_build_star_schema_from_tpcds.sql
psql -U postgres -d dwbench -f 06_build_snowflake_schema_from_tpcds.sql
psql -U postgres -d dwbench -f 07_benchmark_queries_tpcds.sql
psql -U postgres -d dwbench -f 08_collect_metrics.sql
```

## Experimental note

To keep the comparison fair, run the **same semantic queries** against both schemas, on the **same hardware**, with the **same PostgreSQL configuration**, and after executing `ANALYZE`.

# Guiao
## Command List to execute and implement with TPC-DS
1. Pré-requisitos
. PostgreSQL instalado
. psql no terminal
. make, gcc e ferramentas de build
. TPC-DS kit oficial with dsdgen

Linux, normalmente:
sudo apt update
sudo apt install build-essential postgresql postgresql-contrib

No macOS:
brew install postgresql
xcode-select --install

2. Obter o TPC-DS kit

Baixe/clone o kit oficial e localize a pasta tools.

Exemplo esperado:

~/src/tpcds-kit/tools
make

3. Compilar o dsdgen

Entre na pasta do pacote que eu gerei e rode:

bash 01_build_tpcds_tools.sh ../tpcds-kit/tools

Isso vai compilar o gerador de dados.

4. Gerar os dados TPC-DS

Para um piloto:

bash 02_generate_tpcds_data.sh 1 ../tpcds-kit/tools ~/data/tpcds_sf1

Para experimento principal:

bash 02_generate_tpcds_data.sh 10 ../tpcds-kit/tools ~/data/tpcds_sf10

Isso deve gerar arquivos como:

date_dim.dat
customer.dat
customer_address.dat
customer_demographics.dat
item.dat
store.dat
store_sales.dat

5. Criar a base de dados

Crie uma base dedicada:

psql -U postgres -c "CREATE DATABASE dwbench;"

6. Criar as tabelas raw de staging

Rode:

psql -U postgres -d dwbench -f 03_create_raw_tpcds_tables.sql

7. Carregar os dados .dat

Passe o diretório onde os arquivos foram gerados:

psql -U postgres -d dwbench -v data_dir="$HOME/data/tpcds_sf1" -f 04_load_raw_tpcds_data.sql

Se estiver usando SF=10:
sed -i '' 's/|$//' ~/data/tpcds_sf10/*.dat
psql -U postgres -d dwbench -f 04_load_raw_tpcds_data.sql

###psql -U postgres -d dwbench -v data_dir="$HOME/data/tpcds_sf10" -f 04_load_raw_tpcds_data.sql

8. Construir o Star Schema
psql -U postgres -d dwbench -f 05_build_star_schema_from_tpcds.sql

Isso cria o schema:

dw_star_tpcds

9. Construir o Snowflake Schema
psql -U postgres -d dwbench -f 06_build_snowflake_schema_from_tpcds.sql

Isso cria o schema:

dw_snow_tpcds

10. Executar as queries de benchmark
psql -U postgres -d dwbench -f 07_benchmark_queries_tpcds.sql

Essas queries comparam:

receita por categoria e ano
top produtos por lucro
receita por estado
receita por geografia e categoria
ticket médio por trimestre
receita por educação do cliente e categoria



11. Coletar métricas de storage e contagem
psql -U postgres -d dwbench -f 08_collect_metrics.sql

Isso te ajuda a levantar:

tamanho dos objetos
tamanho por schema
contagem de linhas

12. Rodar benchmark repetido

Se quiser várias execuções:

bash 09_run_benchmark.sh dwbench postgres localhost 5432

Os resultados vão para:

benchmark_results/



git clone https://github.com/databricks/tpcds-kit.git
cd tpcds-kit/tools
make

👉 Isso cria o dsdgen

🔹 3. Gerar dataset (IMPORTANTÍSSIMO)
Piloto:
./dsdgen -scale 1 -dir ~/tpcds_data
Experimento:
./dsdgen -scale 10 -dir ~/tpcds_data
🔹 4. Criar base de dados
createdb dwbench
psql dwbench
🔹 5. Criar tabelas RAW

Usa o script que te dei (03_create_raw_tpcds_tables.sql):

psql -d dwbench -f 03_create_raw_tpcds_tables.sql
🔹 6. Importar dados
psql -d dwbench -v data_dir="~/tpcds_data" -f 04_load_raw_tpcds_data.sql

Se der erro aqui → 90% é caminho errado.

🔹 7. Criar STAR SCHEMA
psql -d dwbench -f 05_build_star_schema_from_tpcds.sql
🔹 8. Criar SNOWFLAKE SCHEMA
psql -d dwbench -f 06_build_snowflake_schema_from_tpcds.sql
🔹 9. Rodar queries
psql -d dwbench -f 07_benchmark_queries_tpcds.sql
🔹 10. Medir performance REAL

Dentro do psql:

EXPLAIN ANALYZE SELECT ...

OU:

\timing
📊 O QUE VOCÊ PRECISA COLETAR (PRO PAPER)

Para cada query:

Métrica	Como pegar
Tempo	EXPLAIN ANALYZE
Joins	plano de execução
Storage	pg_total_relation_size
Linhas	COUNT(*)
🔥 COMO ISSO ENTRA NO PAPER

Agora conecta com o que você escreveu:

✔ Methodology

Você escreve:

TPC-DS SF=1 e SF=10
PostgreSQL
mesmas queries em ambos schemas
✔ Results

Você coloca:

tabela:
Query | Star | Snowflake
Q1    | 120  | 210
✔ Discussion (IMPORTANTE PRA NOTA)

Você explica:

👉 “Snowflake is slower due to increased join depth”
👉 “Star reduces execution plan complexity”