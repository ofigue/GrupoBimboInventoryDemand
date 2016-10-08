# Libraries
library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(data.table)
library(plyr)
library(dplyr)
library(sqldf)
library(stringr)
library(caret)

#Data loading
setwd("~/Documents/Data Mining/Competitions/Kaggle/Grupo Bimbo Inventory Demand")
#setwd("C:/Users/Ing-Figueroa/Desktop/Data Mining/Kaggle/Grupo Bimbo Inventory Demand")
train<-fread('train.csv', header = T, sep = ',')
test<-fread('test.csv', header = T, sep = ',')


# Client, product and town loading dataset

client<-fread('cliente_tabla.csv', header = T, sep = ',')
#client_unq<-client %>%
#  filter(!duplicated(NombreCliente))
client_unq<-client[!duplicated(Cliente_ID), ]

# Product
product<-fread('producto_tabla.csv', header = T, sep = ',')

# Get Brands
marcas <-  gsub("\\s*","",str_extract(product$NombreProducto, "\\s[A-Z]{1,3}\\s\\d"))
marcas1 <- str_extract(marcas, "[A-Z]{1,3}")

# Get Weigths
pesos <-  gsub("\\s*","",str_extract(product$NombreProducto, "\\s\\d{1,4}(?:g|Kg|ml)\\s"))

peso <- vector()
medida <- vector()

medida <- str_extract(pesos, "\\D")
peso <- str_extract(pesos, "\\d*")

for (i in 1:2592){
  if(is.na(peso[i]))
  {
    peso[i] <- "0"
  }
}

for (i in 1:2592){
  if(is.na(medida[i]))
  {
    medida[i] <- "0"
  }
}


peso <- as.numeric(peso)

for (i in 1:2592){
  if (medida[i] == "K"){
    peso[i] <- peso[i] * 1000
  }
  if (medida[i] == "m"){
    peso[i] <- peso[i] / 1000
  }
}

# Get product names
nom_corto <- str_extract(product$NombreProducto, "^(\\D*)")
nom_cortito1<-str_extract(nom_corto, "^[a-zA-Z]+")

# FUNCTION as.numeric.factor the nom_cortito
as.numeric.factor <- function(x) {seq_along(levels(x))[x]}
nom_cortito<-as.numeric.factor(as.factor(nom_cortito1))



# Piezas
piezas <-  gsub("\\s*","",str_extract(product$NombreProducto, "(\\d+)p"))
piezas1 <- str_extract(piezas, "[0-9]{1,2}")

# Getting all together
product1 <- as.data.frame(cbind(product$Producto_ID, product$NombreProducto,
                                marcas1, peso, medida, nom_corto, piezas1, nom_cortito))
names(product1) <- c("Producto_ID", "NombreProducto", "Marca", "Peso", "Medida", "Nom_corto",
                     "Piezas", "nom_cortito")

# Get the first number in Town
town<-fread('town_state.csv', header = T, sep = ',')
town$townNumber<-str_extract(town$Town, "([0-9])\\w+")


# Processing in parts to join product data

#train Semana 3
trainS3<-train%>%
  filter(Semana == 3)
trainS3<-merge(client_unq, trainS3, by = "Cliente_ID")
trainS3<-merge(product1, trainS3, by = "Producto_ID")
trainS3<-merge(town, trainS3, by = "Agencia_ID")
clientByTown<-trainS3 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS3<-merge(clientByTown, trainS3, by = "Town")
trainS3$Piezas<-as.numeric(trainS3$Piezas)
trainS3[is.na(trainS3$Piezas),]$Piezas<-1
trainS3$Producto_ID <- as.numeric(trainS3$Producto_ID)
trainS3$Peso <- as.numeric(trainS3$Peso)
trainS3$Canal_ID<-as.factor(trainS3$Canal_ID)
trainS3$PesoDivPiezas<-trainS3$Peso/trainS3$Piezas
write.csv(trainS3, "trainS3.csv", row.names=FALSE)
rm(trainS3)

trainS4<-train%>%
  filter(Semana == 4)
trainS4<-merge(client_unq, trainS4, by = "Cliente_ID")
trainS4<-merge(product1, trainS4, by = "Producto_ID")
trainS4<-merge(town, trainS4, by = "Agencia_ID")
clientByTown<-trainS4 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS4<-merge(clientByTown, trainS4, by = "Town")
trainS4$Piezas<-as.numeric(trainS4$Piezas)
trainS4[is.na(trainS4$Piezas),]$Piezas<-1
trainS4$Producto_ID <- as.numeric(trainS4$Producto_ID)
trainS4$Peso <- as.numeric(trainS4$Peso)
trainS4$Canal_ID<-as.factor(trainS4$Canal_ID)
trainS4$PesoDivPiezas<-trainS4$Peso/trainS4$Piezas
write.csv(trainS4, "trainS4.csv", row.names=FALSE)
rm(trainS4)

trainS5<-train%>%
  filter(Semana == 5)
trainS5<-merge(client_unq, trainS5, by = "Cliente_ID")
trainS5<-merge(product1, trainS5, by = "Producto_ID")
trainS5<-merge(town, trainS5, by = "Agencia_ID")
clientByTown<-trainS5 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS5<-merge(clientByTown, trainS5, by = "Town")
trainS5$Piezas<-as.numeric(trainS5$Piezas)
trainS5[is.na(trainS5$Piezas),]$Piezas<-1
trainS5$Producto_ID <- as.numeric(trainS5$Producto_ID)
trainS5$Peso <- as.numeric(trainS5$Peso)
trainS5$Canal_ID<-as.factor(trainS5$Canal_ID)
trainS5$PesoDivPiezas<-trainS5$Peso/trainS5$Piezas
write.csv(trainS5, "trainS5.csv", row.names=FALSE)
rm(trainS5)

trainS6<-train%>%
  filter(Semana == 6)
trainS6<-merge(client_unq, trainS6, by = "Cliente_ID")
trainS6<-merge(product1, trainS6, by = "Producto_ID")
trainS6<-merge(town, trainS6, by = "Agencia_ID")
clientByTown<-trainS6 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS6<-merge(clientByTown, trainS6, by = "Town")
trainS6$Piezas<-as.numeric(trainS6$Piezas)
trainS6[is.na(trainS6$Piezas),]$Piezas<-1
trainS6$Producto_ID <- as.numeric(trainS6$Producto_ID)
trainS6$Peso <- as.numeric(trainS6$Peso)
trainS6$Canal_ID<-as.factor(trainS6$Canal_ID)
trainS6$PesoDivPiezas<-trainS6$Peso/trainS6$Piezas
write.csv(trainS6, "trainS6.csv", row.names=FALSE)
rm(trainS6)

trainS7<-train%>%
  filter(Semana == 7)
trainS7<-merge(client_unq, trainS7, by = "Cliente_ID")
trainS7<-merge(product1, trainS7, by = "Producto_ID")
trainS7<-merge(town, trainS7, by = "Agencia_ID")
clientByTown<-trainS7 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS7<-merge(clientByTown, trainS7, by = "Town")
trainS7$Piezas<-as.numeric(trainS7$Piezas)
trainS7[is.na(trainS7$Piezas),]$Piezas<-1
trainS7$Producto_ID <- as.numeric(trainS7$Producto_ID)
trainS7$Peso <- as.numeric(trainS7$Peso)
trainS7$Canal_ID<-as.factor(trainS7$Canal_ID)
trainS7$PesoDivPiezas<-trainS7$Peso/trainS7$Piezas
write.csv(trainS7, "trainS7.csv", row.names=FALSE)
rm(trainS7)

trainS8<-train%>%
  filter(Semana == 8)
trainS8<-merge(client_unq, trainS8, by = "Cliente_ID")
trainS8<-merge(product1, trainS8, by = "Producto_ID")
trainS8<-merge(town, trainS8, by = "Agencia_ID")
clientByTown<-trainS8 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS8<-merge(clientByTown, trainS8, by = "Town")
trainS8$Piezas<-as.numeric(trainS8$Piezas)
trainS8[is.na(trainS8$Piezas),]$Piezas<-1
trainS8$Producto_ID <- as.numeric(trainS8$Producto_ID)
trainS8$Peso <- as.numeric(trainS8$Peso)
trainS8$Canal_ID<-as.factor(trainS8$Canal_ID)
trainS8$PesoDivPiezas<-trainS8$Peso/trainS8$Piezas
write.csv(trainS8, "trainS8.csv", row.names=FALSE)
rm(trainS8)

trainS9<-train%>%
  filter(Semana == 9)
trainS9<-merge(client_unq, trainS9, by = "Cliente_ID")
trainS9<-merge(product1, trainS9, by = "Producto_ID")
trainS9<-merge(town, trainS9, by = "Agencia_ID")
clientByTown<-trainS9 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
trainS9<-merge(clientByTown, trainS9, by = "Town")
trainS9$Piezas<-as.numeric(trainS9$Piezas)
trainS9[is.na(trainS9$Piezas),]$Piezas<-1
trainS9$Producto_ID <- as.numeric(trainS9$Producto_ID)
trainS9$Peso <- as.numeric(trainS9$Peso)
trainS9$Canal_ID<-as.factor(trainS9$Canal_ID)
trainS9$PesoDivPiezas<-trainS9$Peso/trainS9$Piezas
write.csv(trainS9, "trainS9.csv", row.names=FALSE)
rm(trainS9)



# test
testS10<-test%>%
  filter(Semana == 10)
testS10<-merge(client_unq, testS10, by = "Cliente_ID")
testS10<-merge(product1, testS10, by = "Producto_ID")
testS10<-merge(town, testS10, by = "Agencia_ID")
clientByTown<-testS10 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
testS10<-merge(clientByTown, testS10, by = "Town")
testS10$Piezas<-as.numeric(testS10$Piezas)
testS10[is.na(testS10$Piezas),]$Piezas<-1
testS10$Producto_ID <- as.numeric(testS10$Producto_ID)
testS10$Peso <- as.numeric(testS10$Peso)
testS10$Canal_ID<-as.factor(testS10$Canal_ID)
testS10$PesoDivPiezas<-testS10$Peso/testS10$Piezas
write.csv(testS10, "testS10.csv", row.names=FALSE)

testS11<-test%>%
  filter(Semana == 11)
testS11<-merge(client_unq, testS11, by = "Cliente_ID")
testS11<-merge(product1, testS11, by = "Producto_ID")
testS11<-merge(town, testS11, by = "Agencia_ID")
clientByTown<-testS11 %>%
  group_by(Town) %>%
  summarise(clientByTown=n())
testS11<-merge(clientByTown, testS11, by = "Town")
testS11$Piezas<-as.numeric(testS11$Piezas)
testS11[is.na(testS11$Piezas),]$Piezas<-1
testS11$Producto_ID <- as.numeric(testS11$Producto_ID)
testS11$Peso <- as.numeric(testS11$Peso)
testS11$Canal_ID<-as.factor(testS11$Canal_ID)
testS11$PesoDivPiezas<-testS11$Peso/testS11$Piezas
write.csv(testS11, "testS11.csv", row.names=FALSE)

gc()

##############################
## Products only in test set
##############################

trainp<-train$Producto_ID
testp<-test$Producto_ID

prod_solo_test<-as.data.frame(setdiff(testp,trainp))
names(prod_solo_test) = "Producto_ID"

faltaTrains<-sqldf('select a.*
      from product a, prod_solo_test b
      where a.Producto_ID = b.Producto_ID')

# prods_solo_test<-merge(test, prod_solo_test, by = "Producto_ID")


# Distinct Marca
length(levels(as.factor(train$Marca)))
length(levels(as.factor(train$Peso)))
length(levels(as.factor(train$Medida)))


# One Hot encoding of marcas
dmy <- dummyVars(" ~ Marca", data = train)
trsf <- data.frame(predict(dmy, newdata = train))
print(trsf)

