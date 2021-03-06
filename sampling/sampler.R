

all <- rbind(read.csv("/home/bjvca/data/projects/digital green/sampling/iganga_admin.csv", header=F),
read.csv("/home/bjvca/data/projects/digital green/sampling/bugiri_admin.csv", header=F),
read.csv("/home/bjvca/data/projects/digital green/sampling/namayingo_admin.csv", header=F),
read.csv("/home/bjvca/data/projects/digital green/sampling/mayuge_admin.csv", header=F),
read.csv("/home/bjvca/data/projects/digital green/sampling/namutumba_admin.csv", header=F))

names(all) <- c("district","county","sc","parish","village")


all$district <- substring(all$district, 4)
all$county <- substring(all$county, 5)
all$sc <- substring(all$sc, 4)
all$parish <- substring(all$parish, 4)
all$village <- substring(all$village, 4)

all$county <- NULL

for (i in 1:dim(all)[1]) {
if (all$district[i] == "") {
all$district[i] <- all$district[i-1]
}
if (all$sc[i] == "") {
all$sc[i] <- all$sc[i-1]
}
if (all$parish[i] == "") {
all$parish[i] <- all$parish[i-1]
}
}


all$sc <- paste(all$district,all$sc, sep = "-")
all$parish <- paste(all$sc,all$parish, sep = "-")
all$village <- paste(all$parish,all$village, sep = "-")

for (j in names(table(all$district))) {
print(j)
print(length(table(all$sc[all$district == j])))
 print(length(table(all$parish[all$district == j])))
print( length(table(all$village[all$district == j])))
}

all <- subset(all, all$sc!="BUGIRI-BUGIRI TOWN COUNCIL")
all <- subset(all, all$sc!="IGANGA-BUSEMBATIA TOWN COUNCIL")
all <- subset(all, all$sc!="IGANGA-CENTRAL DIVISION")
all <- subset(all, all$sc!="MAYUGE-MAYUGE TOWN COUNCIL")
all <- subset(all, all$sc!="MAYUGE-JAGUZI")
all <- subset(all, all$sc!="MAYUGE-MALONGO")
all <- subset(all, all$sc!="MAYUGE-MAYUGE TOWN COUNCIL")
all <- subset(all, all$sc!="NAMAYINGO-NAMAYINGO TOWN COUNCIL")
all <- subset(all, all$sc!="NAMAYINGO-SIGULU ISLANDS") 
all <- subset(all, all$sc!="NAMUTUMBA-NAMUTUMBA TOWN COUNCIL")
### this is rice growing only
all <- subset(all, all$parish !="BUGIRI-BULESA-BUWUNI TOWN BOARD")

set.seed(12345)

sample_set <- all[all$parish %in% sample(all$parish,51),]
### this is the sample
### create the sample
messenger <- c(rep("male",3),rep("female",3),rep("couple",3),"ctrl") 
recipient <- c(rep(c("male","female","couple"),3),"ctrl") 
frame <- data.frame(messenger, recipient)   
###merge sample and frame for the first random 257 combimatins

first_part <- merge(sample_set[sample(nrow(sample_set), 257), ],frame)

### remove the obs that are in first_part from sample set
sample_set <- subset(sample_set, !(village %in% names(table(first_part$village))))

messenger <- c(rep("male",3),rep("female",3),rep("couple",3)) 
recipient <- c(rep(c("male","female","couple"),3)) 
frame <- data.frame(messenger, recipient)  

second_part <- merge(sample_set[sample(nrow(sample_set), 85), ],frame)
first_part <- rbind(first_part, second_part)

### and again, get remaining

sample_set <- subset(sample_set, !(village %in% names(table(first_part$village))))

messenger <- c(rep("male",2),rep("female",2),rep("couple",3)) 
recipient <- c(rep(c("male","female"),2),c("male","female","couple")) 
frame <- data.frame(messenger, recipient)  

second_part <- merge(sample_set[sample(nrow(sample_set), 27), ],frame)
first_part <- rbind(first_part, second_part)

### and again, get remaining

sample_set <- subset(sample_set, !(village %in% names(table(first_part$village))))

messenger <- c(rep("male",2),rep("female",2)) 
recipient <- c(rep(c("male","female"),2)) 
frame <- data.frame(messenger, recipient)  

second_part <- merge(sample_set,frame)
final_sample <- rbind(first_part, second_part)

### now mix in the IVR treatment
final_sample$IVR <- "no"

final_sample[final_sample$recipient == "male" & final_sample$messenger == "male",]$IVR[sample(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "male",]$IVR), floor(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "male",]$IVR)*2/3)) ] <- "yes"


final_sample[final_sample$recipient == "male" & final_sample$messenger == "female",]$IVR[sample(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "female",]$IVR), floor(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "female",]$IVR)*2/3)) ] <- "yes"

final_sample[final_sample$recipient == "male" & final_sample$messenger == "couple",]$IVR[sample(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "couple",]$IVR), floor(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "couple",]$IVR)*2/3)) ] <- "yes"

final_sample[final_sample$recipient == "female" & final_sample$messenger == "male",]$IVR[sample(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "male",]$IVR), floor(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "male",]$IVR)*2/3)) ] <- "yes"


final_sample[final_sample$recipient == "female" & final_sample$messenger == "female",]$IVR[sample(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "female",]$IVR), floor(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "female",]$IVR)*2/3)) ] <- "yes"

final_sample[final_sample$recipient == "female" & final_sample$messenger == "couple",]$IVR[sample(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "couple",]$IVR), floor(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "couple",]$IVR)*2/3)) ] <- "yes"

final_sample[final_sample$recipient == "couple" & final_sample$messenger == "male",]$IVR[sample(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "male",]$IVR), floor(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "male",]$IVR)*2/3)) ] <- "yes"


final_sample[final_sample$recipient == "couple" & final_sample$messenger == "female",]$IVR[sample(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "female",]$IVR), floor(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "female",]$IVR)*2/3)) ] <- "yes"

final_sample[final_sample$recipient == "couple" & final_sample$messenger == "couple",]$IVR[sample(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "couple",]$IVR), floor(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "couple",]$IVR)*2/3)) ] <- "yes"


final_sample$sms <- "no"

final_sample[final_sample$recipient == "male" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"


final_sample[final_sample$recipient == "male" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"

final_sample[final_sample$recipient == "male" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "male" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"

final_sample[final_sample$recipient == "female" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"


final_sample[final_sample$recipient == "female" & final_sample$messenger == "female" & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"

final_sample[final_sample$recipient == "female" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "female" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"

final_sample[final_sample$recipient == "couple" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "male"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"


final_sample[final_sample$recipient == "couple" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "female"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"

final_sample[final_sample$recipient == "couple" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$sms[sample(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$IVR), floor(length(final_sample[final_sample$recipient == "couple" & final_sample$messenger == "couple"  & final_sample$IVR == "yes",]$IVR)/2)) ] <- "yes"


### for ctrl treatment, also balance over who gets to see the video

final_sample[final_sample$messenger == "ctrl",]$recipient[sample(length(final_sample[final_sample$messenger == "ctrl",]$recipient), floor(length(final_sample[final_sample$messenger == "ctrl",]$recipient)/3))] <- "female"

final_sample[final_sample$messenger == "ctrl" & final_sample$recipient != "female",]$recipient[sample(length(final_sample[final_sample$messenger == "ctrl" & final_sample$recipient != "female",]$recipient), floor(length(final_sample[final_sample$messenger == "ctrl" & final_sample$recipient != "female",]$recipient)/2))] <- "male"

final_sample[final_sample$messenger == "ctrl" & final_sample$recipient == "ctrl",]$recipient <- "couple"

sav <- final_sample  
final_sample$sc <- (sapply(strsplit(final_sample$sc,"-"),'[',2))

final_sample$parish <- (sapply(strsplit(final_sample$parish,"-"),'[',3))

final_sample$village <- (sapply(strsplit(final_sample$village,"-"),'[',4))

### correct names of villages to correspond to names of villages in VHT lists

final_sample$village[final_sample$parish =="LUBIRA" & final_sample$village=="MAAWA"] <- "MAWA"

final_sample$village[final_sample$parish =="LUBIRA" & final_sample$village=="BUGALI 'A'"] <- "BUGALI A"
final_sample$village[final_sample$parish =="LUBIRA" & final_sample$village=="BUGALI 'B'"] <- "BUGALI B"
final_sample$village[final_sample$parish =="NANSUMA" & final_sample$village=="MAKALO"] <- "MAAKALO"

final_sample$village[final_sample$parish =="LWANGOSIA" & final_sample$village=="BULOHA WEST"] <- "NSANGO A"
final_sample$village[final_sample$parish =="LWANGOSIA" & final_sample$village=="BULOHA EAST"] <- "BULOHA"

final_sample$village[final_sample$parish =="LUGALA" & final_sample$village=="BUDALA"] <- "BUDALA A"
final_sample$village[final_sample$parish =="LUGALA" & final_sample$village=="BUHIMA"] <- "BUDALA B"
final_sample$village[final_sample$parish =="LUGALA" & final_sample$village=="BUYUNDO"] <- "BUYONDO WEST"

final_sample$village[final_sample$parish =="LUGALA" & final_sample$village=="LUGALA BEACH"] <- "LUGALA A"
final_sample$village[final_sample$parish =="LUGALA" & final_sample$village=="MATALE"] <- "BUYONDO BEACH"
final_sample$village[final_sample$parish =="LUGALA" & final_sample$village=="SISIRO"] <- "LUGALA B"

final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="BUCHUNIA"] <- "BUCHUNIA A"
final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="BWOGOMI"] <- "BUCHUNIA B"
final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="GAMBABWAMI"] <- "BUKOONA"
final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="LUNAYE"] <- "LUTOLO A"
final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="LUTOLO"] <- "LUTOLO B"
final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="NAMABONI"] <- "NANGERA A"
final_sample$village[final_sample$parish =="LUTOLO" & final_sample$village=="NANGERA"] <- "NANGERA B"

final_sample$village[final_sample$parish =="LWANGOSIA" & final_sample$village=="BULOHA EAST"] <- "BULOHA"
final_sample$village[final_sample$parish =="LWANGOSIA" & final_sample$village=="BULOHA WEST"] <- "NSANGO A"

final_sample$village[final_sample$parish =="LWANGOSIA" & final_sample$village=="NAMUTAMBA EAST"] <- "NAMUTABA EAST"
final_sample$village[final_sample$parish =="LWANGOSIA" & final_sample$village=="NAMUTAMBA WEST"] <- "NAMUTABA WEST"
final_sample$head_name <- NA
final_sample$tel_contact <- NA
final_sample$head_name <- as.character(final_sample$head_name)
final_sample$tel_contact <- as.numeric(final_sample$tel_contact)

### change names of missing villages to villages that were sampled additionally
final_sample$district[final_sample$parish =="BUSOWOOBI" & final_sample$village=="NABITOVU"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="BUSOWOOBI" & final_sample$village=="NABITOVU"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="BUSOWOOBI" & final_sample$village=="NABITOVU"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="NABITOVU"] <- "BUDDE"
#BUGIRI-BUDHAYA-BUWOLYA-BUKAGOLO
final_sample$district[final_sample$parish =="BUYEMBA" & final_sample$village=="WALUKUBA"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="BUYEMBA" & final_sample$village=="WALUKUBA"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="BUYEMBA" & final_sample$village=="WALUKUBA"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="WALUKUBA"] <- "BUKAGOLO"
#561  BUGIRI-BUDHAYA-BUWOLYA-BUVUTWA
final_sample$district[final_sample$parish =="LWANIKA" & final_sample$village=="BUTIMBWA"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="LWANIKA" & final_sample$village=="BUTIMBWA"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="LWANIKA" & final_sample$village=="BUTIMBWA"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="BUTIMBWA"] <- "BUVUTWA"
##562   BUGIRI-BUDHAYA-BUWOLYA-KIMASA
final_sample$district[final_sample$parish =="LWANIKA" & final_sample$village=="KASONZI"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="LWANIKA" & final_sample$village=="KASONZI"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="LWANIKA" & final_sample$village=="KASONZI"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="KASONZI"] <- "KIMASA"
##563   BUGIRI-BUDHAYA-BUWOLYA-MAKOVA
final_sample$district[final_sample$parish =="MAGADA" & final_sample$village=="WALUGOGO"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="MAGADA" & final_sample$village=="WALUGOGO"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="MAGADA" & final_sample$village=="WALUGOGO"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="WALUGOGO"] <- "MAKOVA"
##564     BUGIRI-BUDHAYA-BUWOLYA-LUWA
final_sample$district[final_sample$parish =="LUTOLO" & final_sample$village=="SIROWA"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="LUTOLO" & final_sample$village=="SIROWA"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="LUTOLO" & final_sample$village=="SIROWA"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="SIROWA"] <- "LUWA"

###565  BUGIRI-BUDHAYA-BUWOLYA-BITIBWA
final_sample$district[final_sample$parish =="MPANDE (KISEWUZI)" & final_sample$village=="NAMWENDA III"] <- "BUGIRI"
final_sample$sc[final_sample$parish =="MPANDE (KISEWUZI)" & final_sample$village=="NAMWENDA III"] <- "BUDHAYA"
final_sample$parish[final_sample$parish =="MPANDE (KISEWUZI)" & final_sample$village=="NAMWENDA III"] <- "BUWOLYA"
final_sample$village[final_sample$parish =="BUWOLYA" & final_sample$village=="NAMWENDA III"] <- "BITIBWA"

### 3 more villages needed to make up for attrition at listing stage, we can take a random parish in Namayingo, sample(names(table(dta$parishes)),1) yielded BULULE.

final_sample$district[final_sample$parish =="BUYEMBA" & final_sample$village=="NAMBULUKUSA"] <- "NAMAYINGO"
final_sample$sc[final_sample$parish =="BUYEMBA" & final_sample$village=="NAMBULUKUSA"] <- "MUTUMBA"
final_sample$parish[final_sample$parish =="BUYEMBA" & final_sample$village=="NAMBULUKUSA"] <- "BULULE"
final_sample$village[final_sample$parish =="BULULE" & final_sample$village=="NAMBULUKUSA"] <- "BUMACHI"

final_sample$district[final_sample$parish =="BUJWANGA" & final_sample$village=="BUBANGI"] <- "NAMAYINGO"
final_sample$sc[final_sample$parish =="BUJWANGA" & final_sample$village=="BUBANGI"] <- "MUTUMBA"
final_sample$parish[final_sample$parish =="BUJWANGA" & final_sample$village=="BUBANGI"] <- "BULULE"
final_sample$village[final_sample$parish =="BULULE" & final_sample$village=="BUBANGI"] <- "NAHAIGA"

final_sample$district[final_sample$parish =="KIWANYI" & final_sample$village=="KALITUMBA"] <- "NAMAYINGO"
final_sample$sc[final_sample$parish =="KIWANYI" & final_sample$village=="KALITUMBA"] <- "MUTUMBA"
final_sample$parish[final_sample$parish =="KIWANYI" & final_sample$village=="KALITUMBA"] <- "BULULE"
final_sample$village[final_sample$parish =="BULULE" & final_sample$village=="KALITUMBA"] <- "NAMAVUNDU"


write.csv(final_sample, "/home/bjvca/data/projects/digital green/sampling/sampling_list.csv")
#iganga <-  subset(final_sample, district == "IGANGA")
final_sample$ones <- 1
aggr <- aggregate(as.numeric(final_sample$ones),list(final_sample$district, final_sample$sc,final_sample$parish,final_sample$village),sum)
names(aggr) <- c("district","sc","parish","village","hh")

aggr[order(aggr$district,aggr$sc,aggr$parish, aggr$village),]




### this is for listing

final_sample <- sav
final_sample$ones <- 1

agall <- aggregate(final_sample$ones,list(final_sample$village),sum)
names(agall) <- c("village","nr_monogamous_hh")
agall$nr_monogamous_hh <- agall$nr_monogamous_hh + 1
agall$femhead <- 1

agall$district <- (sapply(strsplit(agall$village,"-"),'[',1))
agall$sc <- (sapply(strsplit(agall$village,"-"),'[',2))

agall$parish <- (sapply(strsplit(agall$village,"-"),'[',3))

agall$village <- (sapply(strsplit(agall$village,"-"),'[',4))

agall <- agall[c("district","sc","parish", "village","nr_monogamous_hh", "femhead")]

agall <- agall[order(agall$district,agall$sc,agall$parish, agall$village),]
write.csv(agall, file = "/home/bjvca/data/projects/digital green/sampling/sampling_list_odk.csv")


