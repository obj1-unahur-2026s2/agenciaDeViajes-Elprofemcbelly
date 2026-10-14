class Beneficios {
    const tipo
    const costo
    var vigente = true

    method tipo() {
        return tipo
    }
    
    method costo() {
        return costo
    }
    
    method estaVigente() {
        return vigente
    }

    method cambiarVigencia(unValor) {
        vigente = unValor
    }
}

object guia {
    method cumpleCondicionExtra(coordinador) {
        return coordinador.estaMotivado()
    }
}

object asistenteLogico {
    method cumpleCondicionExtra(coordinador) {
        return coordinador.añosDeExperiencia() >= 3
    }
}  

object acompañante {
    method cumpleCondicionExtra(coordinador) {
        return true
    }
}

class Coordinador {
    const viajesRealizados
    const motivado
    const añosDeExperiencia
    var rol

    method viajesRealizados() {
        return viajesRealizados
    }

    method estaMotivado() {
        return motivado
    }

    method añosDeExperiencia() {
        return añosDeExperiencia
    }

    method rol() {
        return rol
    }

    method estaAltamenteCalificado() {
        return viajesRealizados > 20 and rol.cumpleCondicionExtra(self)    
    }

    method cambiarRol(unRol) {
        if (not [guia, asistenteLogico, acompañante].contains(unRol)) {
            throw new Exception (message = "Rol invalido: solo puede ser guia, asistenteLogico o acompañante")
        }
        rol = unRol
    } 
}

class Pack {
    const duracionEnDias
    const precioBase
    const coordinador
    const beneficios = []

    method duracionEnDias() {
      return duracionEnDias
    }

    method precioBase() {
      return precioBase
    }

    method coordinador() {
      return coordinador
    }

    method beneficios() {
      return beneficios
    }

    method agregarBeneficios(unBeneficio) {
      beneficios.add(unBeneficio)
    }

    method beneficiosVigentes() {
      return beneficios.filter({ b => b.estaVigente() })
    }

    method valorFinal() {
        return precioBase + self.beneficiosVigentes().sum({ b => b.costo() })
    }

    method esPremium()
}

class PackNacional inherits Pack {
    const provincia 
    const actividades

    method provincia() {
        return provincia
    }

    method actividades() {
        return actividades
    }

    method cantidadDeActividades() {
        return actividades.size()
    }

    override method esPremium() {
        return self.duracionEnDias() > 10 and self.coordinador().estaAltamenteCalificado()
    }
}

class PackInternacional inherits Pack {
    const pais
    const escalas
    const esLugarDeInteres

    method pais() {
        return pais
    }

    method escalas() {
        return escalas 
    }

    method esLugarDeInteres() {
        return esLugarDeInteres
    }

    override method esPremium() {
        return self.esLugarDeInteres() and self.duracionEnDias() > 20 and self.escalas() == 0
    } 

    override method valorFinal() = super() * 1.2
}

class PackProvincial inherits PackNacional {
    const cantidadDeCiudades

    method cantidadDeCiudades() {
        return cantidadDeCiudades
    }

    override method esPremium() = self.cantidadDeActividades() >= 4 and cantidadDeCiudades > 5 and self.beneficiosVigentes().size() >= 3

    override method valorFinal() {
        const valorSinAdicional = super()    
        return if (self.esPremium()) valorSinAdicional * 1.05 else valorSinAdicional
    }
}

