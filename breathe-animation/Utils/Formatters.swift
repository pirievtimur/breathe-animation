func minutesSecondsString(seconds: Int) -> String {
    let (m,s) = secondsToMinutesSeconds(seconds: seconds)
    let minutesString = convertValueToTimeRepresentation(value: m)
    let secondsString = convertValueToTimeRepresentation(value: s)
    
    return minutesString + ":" + secondsString
}

func convertValueToTimeRepresentation(value: Int) -> String {
    let string = String(value)
    return string.count > 1 ? string : "0" + string
}

func secondsToMinutesSeconds(seconds: Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
}
