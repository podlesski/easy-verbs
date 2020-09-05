class IrregularVerb: Codable {
    let infinitive, pastSimple, pastParticiple, description: String?

    enum CodingKeys: String, CodingKey {
        case infinitive
        case pastSimple = "past_simple"
        case pastParticiple = "past_participle"
        case description
    }

    init(infinitive: String?, pastSimple: String?, pastParticiple: String?, purpleDescription: String?) {
        self.infinitive = infinitive
        self.pastSimple = pastSimple
        self.pastParticiple = pastParticiple
        self.description = purpleDescription
    }
}
