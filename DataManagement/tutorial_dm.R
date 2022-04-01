#####Tutorial para gerar diagrama de entidade-relacionamento automaticamente usando R

##how to

##instalar o devtools
##instalar o dm
##carregar dm
##carregar n tabelas

##recomendado instalar o DiagrammeR e o DiagrammeRsvg dentro da instalação do R para os gráficos funcionarem devidamente


# install.packages("devtools")
require(devtools)

options(scipen = 999)
#devtools::install_github("cynkra/dm")
#devtools::install_version("DiagrammeR", version = "1.0.6.1", repos = "http://cran.us.r-project.org")

library(dm)
library(readr)
library(readxl)

##carga de tabelas

##dados de teste
products = readr::read_csv("products.csv")
counties = readr::read_csv("counties.csv")
sales = readr::read_csv("sales.csv")
stores = readr::read_csv("stores.csv")
stores_convenience = readr::read_csv("stores_convenience.csv")

##insere os dados dentro de um dm, todas as tabelas precisam entrar aqui dentro
dm_test <- dm(products, 
            counties, 
            sales, 
            stores,
            stores_convenience)


##definir as chaves primárias
dm_test_pk <-
  dm_test %>%
  dm_add_pk(table = products, columns = item_no) %>%
  dm_add_pk(table = counties, columns = county_number) %>% 
  dm_add_pk(table = stores, columns = store) %>% 
  dm_add_pk(table = stores_convenience, columns = store)
dm_test_pk


##definir as chaves estrangeiras
dm_test_all_keys <-
  dm_test_pk %>%
  dm_add_fk(table = sales, columns = store, ref_table = stores) %>%
  dm_add_fk(table = sales, columns = county_number, ref_table = counties) %>% 
  dm_add_fk(table = sales, columns = item, ref_table = products) %>%
  dm_add_fk(table = stores, columns = store, ref_table = stores_convenience)


##definir cor e plotar
dm_test_all_keys %>%
  dm_set_colors(blue = c(sales), 
                darkblue = stores, 
                grey = c(counties, products, stores_convenience)) %>% 
  dm_draw(rankdir = "TB", column_types = TRUE, view_type = "all")



