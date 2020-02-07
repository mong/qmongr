## code to prepare `DATASET` dataset goes here

#Denne funker bare når database tilgjengelig!:
library(nakke)
RegData <- NakkeRegDataSQL()
RegData <- NakkePreprosess(RegData)

#tilretteleggDataNakke <- function(RegData = RegData, valgtVar, filUt=paste0('Nakke', valgtVar)
#valgtVar <- 'beinsmLavPre' #beinsmLavPre, peropKompDura, sympVarighUtstr, NDIendr12mnd35pst
datoFra = '2014-01-01'
aar=0

KvalIndDataNakke <- tilretteleggDataNakke(RegData = RegData, datoFra = '2014-01-01', aar=0,
                            filUt='dummy')  #valgtVar, 

usethis::use_data(KvalIndDataNakke, overwrite = TRUE)


IndBeskrNakke <- read.csv('data-raw/Indikatorbeskrivelser.csv', sep = ';')
usethis::use_data(IndBeskrNakke, overwrite = TRUE)


#--------  FUNKSJONER --------------------------------

#' Generere data til offentlig visning.
#'
#' @param filUt tilnavn for utdatatabell (fjern?)
#' @param RegData - data
#' @param valgtVar -
#' @param datoFra - startdato
#' @param aar - velge hele år (flervalg)
#' @return Datafil til Resultatportalen
#' @export

tilretteleggDataNakke <- function(RegData = RegData, datoFra = '2014-01-01', aar=0,
                           filUt='dummy'){ #valgtVar, 
  
nyID <- c('114288'='4000020', '109820'='974589095', '105783'='974749025',
          '103469'='874716782', '601161'='974795787', '999920'='913705440',
          '105588'='974557746', '999998'='999998', '110771'='973129856',
          '4212372'='4212372', '4211880'='999999003', '4211879'='813381192')
RegData$SykehusId <- as.character(nyID[as.character(RegData$ReshId)])
resultatVariable <- c('KvalIndId', 'Aar', "ShNavn", "ReshId", "SykehusId" , "Variabel")
NakkeKvalInd <- data.frame(NULL) #Aar=NULL, ShNavn=NULL)

kvalIndParam <- c('KomplSvelging3mnd', 'KomplStemme3mnd', 'Komplinfek', 'NDIendr12mnd35pstKI')
indikatorID <- c('nakke1', 'nakke2', 'nakke3', 'nakke4')


for (valgtVar in kvalIndParam){

  myelopati <- if (valgtVar %in% c('KomplStemme3mnd', 'KomplSvelging3mnd')) {0} else {99}
  fremBak <- if (valgtVar %in% c('KomplStemme3mnd', 'KomplSvelging3mnd', 'NDIendr12mnd35pstKI')) {1} else {0}
  #filUt <- paste0('NakkeKvalInd', ifelse(filUt=='dummy',  valgtVar, filUt), '.csv')
  NakkeVarSpes <- NakkeVarTilrettelegg(RegData=RegData, valgtVar=valgtVar, figurtype = 'andelGrVar')
  NakkeUtvalg <- NakkeUtvalgEnh(RegData=NakkeVarSpes$RegData, aar=aar, datoFra = datoFra,
                                myelopati=myelopati, fremBak=fremBak) #, hovedkat=hovedkat) # #, datoTil=datoTil)
  NakkeKvalInd1 <- NakkeUtvalg$RegData[ , resultatVariable]
  NakkeKvalInd1$kvalIndID <- indikatorID[which(kvalIndParam == valgtVar)]
  
  NakkeKvalInd <- rbind(NakkeKvalInd, NakkeKvalInd1)
  #info <- c(NakkeVarSpes$tittel, NakkeUtvalg$utvalgTxt)
  #NakkeKvalInd$info <- c(info, rep(NA, dim(NakkeKvalInd)[1]-length(info)))
}  

  # 114288=4000020, 109820=974589095, 105783=974749025, 103469=874716782, 601161=974795787, 999920=913705440,
  # 105588=974557746, 999998=999998, 110771=973129856, 4212372=4212372, 4211880=999999003, 4211879=813381192
  #test <- as.character(nyID[as.character(x)])
  # ReshId=OrgID
  # 114288=4000020              Stavanger USH
  # 109820=974589095           OUS, Ullevål USH
  # 105783=974749025        Trondheim, St. Olav
  # 103469=874716782                  OUS, RH
  # 601161=974795787                Tromsø, UNN
  # 999920=913705440    Oslofjordklinikken Vest
  # 105588=974557746              Haukeland USH
  # 999998=999998        Oslofjordklinikken
  # 110771=973129856                     Volvat
  # 4212372=4212372      Aleris Colosseum Oslo
  # 4211880=999999003             Aleris Nesttun
  # 4211879=813381192 Aleris Colosseum Stavanger
  return(invisible(NakkeKvalInd))
}

