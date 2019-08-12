rm(list = ls())

# Os 15 primeiros pacotes s�o os que sempre dou "library", s� para garantir
# Os �ltimos 6 s�o necess�rios para o loop
library(bit64)
library(data.table)
library(descr)
library(readr)
library(survey)
library(checkmate)
library(lme4)
library(oaxaca)
library(dplyr)
library(ggplot2)
library(gganimate)
library(gifski)
library(png)
library(transformr)
library(zoo)
library(foreach)
library(readxl)
library(reshape2)
library(geobr)
library(scales)
library(maptools)
library(RColorBrewer)
library(stringi)
library(PNADcIBGE)

# � preciso definir qualquer endere�o, para salvar o mapa
wd <- "C:/Users/DaniellaBritto/Desktop/PNADs/PNADsCont/PNADC - dta Novo Dicion�rio (2019)"

setwd(wd)

# Importar PNADC de qualquer trimestre
PNADC2019_1 <- read_pnadc(microdata = "PNADC_012019_20190516.txt", input_txt="Input_PNADC_trimestral.txt", vars= c("UPA", "UF", "Trimestre", "Ano", "V1008", "V1014", "V1016", "V2007", "V2010", "V1022", "V20082", "VD4002",  "V2008", "V20081", "VD4031", "VD3004", "V2009", "VD4019", "V4040", "V40401", "V40402", "V40403", "VD3005"))

# Usar pacote geobr para pegar mapa dos Estados
UF <- read_state(year=2010,code_state="all")

PNADC2019_1 <- PNADC2019_1 %>% mutate(desemp=ifelse(VD4002==2,1,ifelse(VD4002==1,0,NA)))

PNADCState <- PNADC2019_1 %>% group_by(`UF`) %>% summarise(Desemprego=mean(desemp,na.rm=T)*100) 

PNADCState <- PNADCState %>% rename(code_state=UF)

PNADCUF <- left_join(UF,PNADCState,by="code_state")


plot1 <-   ggplot() + geom_sf(data=PNADCUF, aes(fill= Desemprego),
                              color = "grey", size = 0.01) +
  scale_fill_distiller(palette = "Reds", 
                       breaks = pretty_breaks(n = 10),
                       direction=1)+
  guides(fill = guide_legend(reverse = TRUE))+
  labs(title="Desemprego por Estado (em %)",caption="Fonte: PNAD Cont�nua 1�Tri/19")

ggsave(plot1,file="Desemprego.png")