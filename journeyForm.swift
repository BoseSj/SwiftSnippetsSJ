enum TravelMode {
    case bus
    case train
    case flight
    case ship
}

enum TravelType {
    case singleJourney
    case returnJourney
    case multipleJourney
}


protocol TripTypeForm {}
class SingleJourneyForm: TripTypeForm {

    var departureStation: String!
    var arrivalStation: String!

    init(departure: String = "", arrival: String = "") {
        self.departureStation = departure
        self.arrivalStation   = arrival
    }


    func announce(){
        print("Single Journey from \(self.arrivalStation ?? "*") to \(self.departureStation ?? "_")")       
    }
}

class ReturnJourneyForm: TripTypeForm {

    var upJourney: SingleJourneyForm
    var downJourney: SingleJourneyForm

    init(upJourney: SingleJourneyForm = SingleJourneyForm(), downJourney: SingleJourneyForm = SingleJourneyForm()) {
        self.upJourney = upJourney
        self.downJourney = downJourney
    }

    init(departure: String, arrival: String) {
        self.upJourney = SingleJourneyForm(departure: departure, arrival: arrival)
        self.downJourney = SingleJourneyForm(departure: arrival, arrival: departure)
    }

}

class MultipleJourneyForm: TripTypeForm {

    var allJourneys: [SingleJourneyForm]

    init(allJourneys: [SingleJourneyForm] = [SingleJourneyForm]()) {
        self.allJourneys = allJourneys
    }

}



protocol TravelModeForm {}
class BusForm: TravelModeForm {

    var journeyType: TravelType

    var journeyDetails: TripTypeForm?

    init(journeyDetails: TripTypeForm = SingleJourneyForm(), journeyType: TravelType = .singleJourney) {
        self.journeyDetails = journeyDetails
        self.journeyType = journeyType
    }

    // to change journey type to single trip and mutlitrip we can call the init() again to reinitialize everything

    // but for round trip we need a method we need a bit help
    func changeToRoundTrip() {
        if self.journeyType == .singleJourney {
            let trip = self.journeyDetails as? SingleJourneyForm

            if let trip {
                self.journeyDetails = ReturnJourneyForm(departure: trip.departureStation, arrival: trip.arrivalStation)
            }
        } 
        else if self.journeyType == .multipleJourney {
            self.journeyDetails = ReturnJourneyForm()
        }
        self.journeyType = .returnJourney
    }    
}

class TrainForm: TravelModeForm {

    var journeyType: TravelType

    var journeyDetails: TripTypeForm?

    init(journeyDetails: TripTypeForm = SingleJourneyForm(), journeyType: TravelType = .singleJourney) {
        self.journeyDetails = journeyDetails
        self.journeyType = journeyType
    }
}

struct FormData {
    var travelMode: TravelMode
    var tripType: TripTypeForm = SingleJourneyForm()
    var unknownJourneyForm: TripTypeForm?
}
class JourneyForm {

    var busJourney: BusForm?
    var trainJourney: TrainForm?


    // For the sake of tableView
    var JourneyFormData: [FormData]



    init(busJourney: BusForm? = nil, trainJourney: TrainForm? = nil) {
        self.busJourney = busJourney
        self.trainJourney = trainJourney
    }


    //

}

// Create a Journey form 
// Single Bus journey from earth to venus
// then Multiple Train joureny from venus to mercury, mercury to mars, mars to earth


var SpaceJourney = JourneyForm()

SpaceJourney.trainJourney = {
    let multiJourneyForms = MultipleJourneyForm()
    multiJourneyForms.allJourneys.append(SingleJourneyForm(departure: "Venus", arrival: "Mercury"))
    multiJourneyForms.allJourneys.append(SingleJourneyForm(departure: "Mercury", arrival: "Mars"))
    multiJourneyForms.allJourneys.append(SingleJourneyForm(departure: "Mars", arrival: "Earth"))

    return TrainForm(journeyDetails: multiJourneyForms, journeyType: .multipleJourney)
}()


// printing data


var unknownFormData: [FormData] = [FormData]()


switch SpaceJourney.busJourney?.journeyType {
    case .singleJourney:
        let journey = SpaceJourney.busJourney?.journeyDetails as? SingleJourneyForm

        if let journey {
            unknownFormData.append(FormData(travelMode: .bus, unknownJourneyForm: journey))
        }
    case .multipleJourney:
        let journey = SpaceJourney.busJourney?.journeyDetails as? MultipleJourneyForm

        if let journey {
            for trip in journey.allJourneys {
                unknownFormData.append(FormData(travelMode: .bus, unknownJourneyForm: trip))
            }
        }
    default:
    print("Nothing for now")
}

switch SpaceJourney.trainJourney?.journeyType {
    case .singleJourney:
        let journey = SpaceJourney.trainJourney?.journeyDetails as? SingleJourneyForm

        if let journey {
            unknownFormData.append(FormData(travelMode: .train, unknownJourneyForm: journey))
        }
    case .multipleJourney:
        let journey = SpaceJourney.trainJourney?.journeyDetails as? MultipleJourneyForm

        if let journey {
            for trip in journey.allJourneys {
                unknownFormData.append(FormData(travelMode: .train, unknownJourneyForm: trip))
            }
        }
    default:
    print("Nothing for now")
}


// Print


for trip in unknownFormData {
    if trip.travelMode == .bus {
        print(" ======= BUS ======= ")
        print()
        
        let tripDetails = trip.unknownJourneyForm as? SingleJourneyForm

        if let tripDetails {
            tripDetails.announce()
            print()
        }
    }
    else if trip.travelMode == .train {
        print(" ======= TRAIN ======= ")
        print()
        
        let tripDetails = trip.unknownJourneyForm as? SingleJourneyForm

        if let tripDetails {
            tripDetails.announce()
            print()
        }
    } else {
        print(" ======= UNKNOWN ======= ")

    }
}

print(" ====== NUMBER OF FORMS ====== ")
print(unknownFormData.count)

