class_name Troops

var Name
var Key
var TerritoryKey

var Count

var Experience

#NOTE: COULD BE DONE AS A MULTIPLIER THING
var LVL

func _init(_Name, _Key, _TerritoryKey, _Count):
    Name = _Name
    Key = _Key
    TerritoryKey = _TerritoryKey
    Count = _Count
    Experience = 0
    LVL = 1

func GetForce():
    return Count * LVL

func GainExperience(experience):
    Experience += experience
    #FIXME: LVL SCHEME