
class Barco{
	var tripulantes = new List()
	var mision
	var capacidad
	
	constructor(misionBarco, capacidadBarco, tripulantesBarco){
		self.mision(misionBarco)
		capacidad = capacidadBarco
		self.tripulantes(tripulantesBarco)
	}
	
	method tripulantes(){
		return tripulantes
	}
	
	method mision(){
		return mision
	}
	
	method capacidad(){
		return capacidad
	}
	
	method tripulantes(cantidad){
		tripulantes = cantidad
	}
	
	method mision(nuevaMision){
		mision = nuevaMision
		self.renovarTripulacion()
	}
	
	method agregarTripulante(tripulante){
		if(tripulante.puedeSerParteDe(self)) tripulantes.add(tripulante)
	}
	
	method esTemible(){
		mision.puedeSerRealizadaPor(self)
	}
	
	method cantidadTripulantes(){
		return tripulantes.size()
	}
	
	method tieneSuficienteTripulacion(){
		return self.cantidadTripulantes() >= capacidad*0.9
	}
	
	method esVulnerableA(barcoAtacante){
		return self.cantidadTripulantes() <= (barcoAtacante.cantidadTripulantes() /2)
	}
	
	method puedeSerSaqueadoPor(pirata){
		return pirata.pasadoDeGrogXD()
	}
	
	method tripulacionPasadaDeGrogXD(){
		return tripulantes.all({tripulante => tripulante.pasadoDeGrogXD()})
	}
	
	method cantidadTripulantesPasadosDeGrogXD(){
		return self.tripulantesPasadosDeGrogXD().size()
	}
	
	method tripulantesPasadosDeGrogXD(){
		return tripulantes.filter({tripulante => tripulante.pasadoDeGrogXD()})
	}
	
	method tripulantePasadoDeGrogXDMasRico(){
		return self.tripulantesPasadosDeGrogXD().max({tripulante => tripulante.dinero()})
	}
	
	method tiposDistintosItemsTripulantesPasadosDeGrogXD(){//5B
		a
	}
	
	method lugaresLibres(){
		return capacidad - self.cantidadTripulantes()
	}
	
	method tieneLugar(){
		return self.lugaresLibres() > 0
	}
	
	method tripulantesUtiles(){
		return tripulantes.filter({tripulante => tripulante.esUtil(mision)})
	}
	
	method renovarTripulacion(){
		tripulantes = self.tripulantesUtiles()		
	}
	
	method tripulanteMasEbrio(){
		return tripulantes.max({tripulante => tripulante.ebriedad()})
	}
	
	method dejaTripulacion(tripulante){
		tripulantes = tripulantes.remove(tripulante)
	}
	
	method anclarEn(ciudad){
		tripulantes.forEach({tripulante => tripulante.tomarGrogXD()})
		self.dejaTripulacion(self.tripulanteMasEbrio())
		ciudad.agregarHabitantes(1)
	}
	
	method quienInvitoMas(){
		//6
	}
	
}

class Pirata{
	var items = new List()
	var nombre
	var ebriedad
	var dinero
	var invitadoPor
	
	constructor(nombrePirata, dineroPirata, ebriedadPirata, itemsPirata, pirataInvitadoPor){
		nombre = nombrePirata
		self.dinero(dineroPirata)
		self.ebriedad(ebriedadPirata)
		items = itemsPirata
		invitadoPor = pirataInvitadoPor
	}
	
	method nombre(){
		return nombre
	}
	
	method ebriedad(){
		return ebriedad
	}
	
	method dinero(){
		return dinero
	}
	
	method items(){
		return items
	}
	
	method invitadoPor(){
		return invitadoPor
	}
	
	method ebriedad(nivel){
		ebriedad = nivel
	}
	
	method dinero(cantidad){
		dinero = cantidad
	}
	
	method agregarItem(nuevoItem){
		items.add(nuevoItem)
	}
	
	method tieneItem(item){
		return items.contains(item)
	}
	
	method cantidadItems(){
		return items.size()
	}
	
	method esUtil(mision){
		return mision.tripulanteUtil(self)
	}
	
	method pasadoDeGrogXD(){
		return self.masEbriedadQue(90)
	}
	
	method masEbriedadQue(nivel){
		return ebriedad >= nivel
	}
	
	method seAnimaASaquear(victima){
		victima.puedeSerSaqueadoPor(self)	
	}
	
	method puedeSerParteDe(barco){
		return barco.tieneLugar() && self.esUtil(barco.mision())
	}
	
	method noTieneDinero(){
		return dinero == 0
	}
	
	method tomarGrogXD(){
		ebriedad += 5
		if(self.noTieneDinero()){
			throw new Exception("pirata no tiene dinero")
		}
		dinero -= 1
	}
	
	method esEspiaDeLaCorona(){
		return (!self.pasadoDeGrogXD()) && self.seAnimaASaquear(victima) //PTO 4B
	}
}

class Mision{
	method puedeSerRealizadaPor(barco){
		return barco.tieneSuficienteTripulacion()
	}
	
}

class BusquedaDelTesoro inherits Mision{
	
	method tripulateUtil(tripulante){
		return (tripulante.items().contains("brujula") or tripulante.items().contains("mapa") or tripulante.items().contains("grogXD")) && (tripulante.dinero() <= 5)
	}
	
	override method puedeSerRealizadaPor(barco){
		super(barco)
		return barco.tripulantes().any({tripulante => tripulante.tieneItem("llave")})
	}
}

class ConvertirseEnLeyenda inherits Mision{
	var itemObligatorio
	constructor(itemLeyenda){
		itemObligatorio = itemLeyenda
	}
	
	method tripulateUtil(tripulante){
		return (tripulante.cantidadItems() >= 10) && (tripulante.tieneItem(itemObligatorio))
	}
}

class Saqueo inherits Mision{
	var victima
	var mayorMonto
	constructor(victimaMision, mayorMontoMision){
		victima = victimaMision
		mayorMonto = mayorMontoMision
	}
	method tripulateUtil(tripulante){
		return (tripulante.dinero() < mayorMonto) && tripulante.seAnimaASaquear(victima) 
	}
	
	method mayorMonto(nuevoMonto){
		mayorMonto = nuevoMonto
	}
	
	override method puedeSerRealizadaPor(barco){
		super(barco)
		return victima.esVulnerableA(barco)
	}
}

class Ciudad{
	var habitantes
	constructor(habitantesCiudad){
		habitantes = habitantesCiudad
	}
	
	method agregarHabitantes(cantidad){
		habitantes += cantidad
	}
	
	method esVulnerableA(barcoAtacante){
		return (barcoAtacante.cantidadTripulantes() >= 0.4*habitantes) or barcoAtacante.tripulacionPasadaDeGrogXD()
	}
	
	method puedeSerSaqueadoPor(pirata){
		return pirata.masEbriedadQue(50)
		
	}
}