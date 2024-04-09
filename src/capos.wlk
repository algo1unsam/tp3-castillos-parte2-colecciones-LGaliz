object espada{
    var property uso = false

    method poder(unPersonaje) = if(not uso) unPersonaje.poderBase()  else  unPersonaje.poderBase() / 2 
    
    method usar(){
    	uso = true
    }
}

object collar {
    var property uso = 0
    const poderBase = 3
   
    method poder(unPersonaje) = if(unPersonaje.poderBase() > 6)  poderBase + uso   else  poderBase
    
    method usar(){
    	uso += 1
    }
}

object armadura {
	const poderBase = 6
  	
  	method usar(){}
	method poder(personaje) = poderBase
}

object bendicion {
	method poder(personaje) = 4
}

object invisibilidad {
	method poder(personaje) = personaje.poderBase()
}

object invocacion {
	method poder(personaje) = self.artefactoMasPoderoso(personaje).poder(personaje)	
	method artefactoMasPoderoso(personaje) = castillo.artefactos().max({artefacto => artefacto.poder(personaje)})
}

object libro {
	const property hechizos = [bendicion,invisibilidad, invocacion]
	 method usar(){
	 		hechizos.remove(hechizos.first())
	 }

	method poder(personaje) = if(hechizos.size() != 0)  hechizos.first().poder(personaje) else  0  //if (hechizos.isEmpty())
}

object castillo {
	const property artefactos = #{}
		
	method agregarArtefactos(_artefactos) {
		artefactos.addAll(_artefactos)		
	}
}

object rolando {
	const property artefactos = #{}
	const property historia = []
	var property capacidad = 2
	var property poderBase = 5

	method encontrar(artefacto) {
		if(artefactos.size() < capacidad) {
			artefactos.add(artefacto)
		}
		historia.add(artefacto)
	}
	
	method volverACasa(lugar) {
		lugar.agregarArtefactos(artefactos)
		artefactos.clear()
	}	
	
	method batalla(){
		poderBase += 1
		artefactos.forEach({artefacto => artefacto.usar()})
	}
	
	method posesiones() = self.artefactos() + castillo.artefactos()
	method tiene(artefacto) = self.posesiones().contains(artefacto)	
	method poder() = poderBase + self.poderDeTodosLosArtefactos()
	method poderDeTodosLosArtefactos() = artefactos.sum({item => item.poder(self)}) 
	method tieneArmaFatal(enemigo) = artefactos.any({artefacto => artefacto.poder(self)>enemigo.poder()})
	method armaFatal(enemigo) = artefactos.find({artefacto => artefacto.poder(self)>enemigo.poder()})	
}

//ENEMIGOS
object palacio {}
object fortaleza {}
object torre {}

object archibaldo {
	method poder() = 16
	method morada() = palacio
}

object caterina {
	method poder() = 28
	method morada() = fortaleza
}

object astra {
	method poder() = 14
	method morada() = torre
}

object eretia {
	var property enemigos = #{archibaldo,caterina,astra}
	
	method enemigosVencibles(persona) = enemigos.filter({enemigo => enemigo.poder()<persona.poder()})
	method moradasConquistables(persona) = self.enemigosVencibles(persona).map({item => item.morada()}).asSet()
	method poderoso(persona) = enemigos.all({enemigo => enemigo.poder()<persona.poder()})
}