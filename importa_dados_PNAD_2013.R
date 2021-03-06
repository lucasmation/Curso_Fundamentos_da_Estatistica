setwd('C:/Users/lucas_000/')

#lendo o dicion�rio
library(readxl)
library(dplyr)
read_excel('pnad2013/Dicion�rios e input/Dicion�rio de vari�veis de pessoas - PNAD 2013.xls',
           skip = 5, col_names=c('inicio','tamanho','cod','D','E','F','G','H'),
           col_types=c('numeric','numeric','text','text','text','text','text','text')
           )[1:3] %>% filter(!is.na(inicio)) %>% mutate(fim=inicio+tamanho-1) -> dic_pes

#convertendo arquivo de dados de "largura fixa" para CSV
library(descr)
fwf2csv("pnad2013/dados/pes2013.txt", 
        "pnad2013/dados/pes2013.csv", 
        dic_pes$cod, dic_pes$inicio, dic_pes$fim)



#importando para R e Selecionando algumas vari�veis:
read.csv( "pnad2013/dados/pes2013.csv" , sep = "\t") %>%
  select(V0302,V8005,V0404,V0713,V4803, V4720,V4729) -> pnad2013_pes

#renomeando as vari�veis
names(pnad2013_pes) <- c('sexo','idade','raca','horas_trabalhadas','anos_de_estudo','renda_total','peso_pes')

#atribuindo os labels das categ�ricas, definindo-as como fatores
pnad2013_pes %>% mutate( sexo = factor(sexo),
                         raca = factor(raca)) -> pnad2013_pes 
levels(pnad2013_pes$sexo) <- c('M','F')
levels(pnad2013_pes$raca) <- c('Ind�gena','Branca','Preta','Amarela','Parda', 'Amarela','Sem declara��o')



#acertando valor aberrante de sal�rio:
pnad2013_pes$sexo <- factor(pnad2013_pes$sexo,c('M','F'))
pnad2013_pes %>% filter(renda_total<100000000) -> pnad2013_pes

#Salvando em CSV e formato .Rda
write.csv2(pnad2013_pes,'Curso_Fundamentos_da_Estatistica/data/pnad2013_pes_mastigada.csv')
save(pnad2013_pes,file='Curso_Fundamentos_da_Estatistica/data/pnad2013_pes_mastigada.Rda')

