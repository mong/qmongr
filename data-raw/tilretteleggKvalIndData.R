## code to prepare `DATASET` dataset goes here
#' Generere data til offentlig visning. Kan hende denne må deles i to? 
#'
#' @param filUt tilnavn for utdatatabell (fjern?)
#' @param RegData - data
#' @param valgtVar - beinsmLavPre, peropKompDura, sympVarighUtstr, NDIendr12mnd35pst
#' @param datoFra - startdato
#' @param aar - velge hele år (flervalg)
#' @return Datafil til Resultatportalen
#' @export

tilretteleggDataNakke <- function(RegData = RegData, valgtVar, datoFra = '2014-01-01', aar=0,
                           filUt='dummy'){ 
  
  if (valgtVar %in% c('KomplStemme3mnd', 'KomplSvelging3mnd')) {myelopati <- 0}
  if (valgtVar == 'NDIendr12mnd35pst') {
    myelopati <- 0
    fremBak<-1}
  filUt <- paste0('NakkeTilRes', ifelse(filUt=='dummy',  valgtVar, filUt), '.csv')
  NakkeVarSpes <- NakkeVarTilrettelegg(RegData=RegData, valgtVar=valgtVar, figurtype = 'andelGrVar')
  NakkeUtvalg <- NakkeUtvalgEnh(RegData=NakkeVarSpes$RegData, aar=aar, datoFra = datoFra,
                                myelopati=myelopati, fremBak=fremBak) #, hovedkat=hovedkat) # #, datoTil=datoTil)
  NakkeTilResvalgtVar <- NakkeUtvalg$RegData[ ,c('Aar', "ShNavn", "ReshId", "Variabel")]
  
  ##x <- unique(tab$ReshId)
  nyID <- c('114288'='4000020', '109820'='974589095', '105783'='974749025',
            '103469'='874716782', '601161'='974795787', '999920'='913705440',
            '105588'='974557746', '999998'='999998', '110771'='973129856',
            '4212372'='4212372', '4211880'='999999003', '4211879'='813381192')
  NakkeTilResvalgtVar$ID <- as.character(nyID[as.character(NakkeTilResvalgtVar$ReshId)])
  info <- c(NakkeVarSpes$tittel, NakkeUtvalg$utvalgTxt)
  NakkeTilResvalgtVar$info <- c(info, rep(NA, dim(NakkeTilResvalgtVar)[1]-length(info)))
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
  
  
  return(invisible(NakkeTilResvalgtVar))
}
usethis::use_data("DATASET")
